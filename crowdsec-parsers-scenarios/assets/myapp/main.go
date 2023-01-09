package main

import (
	"flag"
	"fmt"
	"net/http"
	"strings"

	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"

	"github.com/gin-gonic/gin"
)

var password, user string

func main() {
	flag.StringVar(&user, "user", "user", "User arg")
	flag.StringVar(&password, "password", "password", "Password arg")
	flag.Parse()
	router := gin.Default()
	router.LoadHTMLGlob("templates/*.html")

	router.Use(sessions.Sessions("session", cookie.NewStore([]byte("sup3rs3cr3t"))))

	i := router.Group("/")
	{
		i.GET("/", func(c *gin.Context) {
			session := sessions.Default(c)
			user := session.Get("user")
			if user != nil {
				c.HTML(http.StatusBadRequest, "index.html",
					gin.H{
						"content": "Please logout first",
						"user":    user,
					})
				return
			}
			c.HTML(http.StatusOK, "index.html", gin.H{
				"content": "",
				"user":    user,
			})
		})
		i.POST("/", func(c *gin.Context) {
			session := sessions.Default(c)
			user := session.Get("user")
			if user != nil {
				c.HTML(http.StatusBadRequest, "index.html", gin.H{"content": "Please logout first"})
				return
			}

			u := c.PostForm("username")
			p := c.PostForm("password")

			if EmptyUserPass(u, p) {
				c.HTML(http.StatusBadRequest, "index.html", gin.H{"content": "Parameters can't be empty"})
				return
			}

			if !CheckUserPass(u, p) {
				c.HTML(http.StatusUnauthorized, "index.html", gin.H{"content": "Incorrect username or password"})
				return
			}

			session.Set("user", u)
			if err := session.Save(); err != nil {
				c.HTML(http.StatusInternalServerError, "index.html", gin.H{"content": "Failed to save session"})
				return
			}

			c.Redirect(http.StatusMovedPermanently, "/admin")
		})
	}
	p := router.Group("/")
	{
		p.Use(func(c *gin.Context) {
			session := sessions.Default(c)
			user := session.Get("user")
			fmt.Println("Auth middleware", user)
			if user == nil {
				c.Redirect(http.StatusMovedPermanently, "/")
				c.Abort()
				return
			}
			c.Next()
		})
		p.GET("/admin", func(c *gin.Context) {
			session := sessions.Default(c)
			user := session.Get("user")
			c.HTML(http.StatusOK, "admin.html", gin.H{
				"content": "This is a dashboard",
				"user":    user,
			})
		})
		p.GET("/logout", func(c *gin.Context) {
			session := sessions.Default(c)
			user := session.Get("user")
			fmt.Println("Trying to logout")
			if user == nil {
				return
			}
			session.Delete("user")
			if err := session.Save(); err != nil {
				return
			}

			c.Redirect(http.StatusMovedPermanently, "/")
		})
	}
	router.Run("0.0.0.0:3000")
}

func CheckUserPass(u, p string) bool {
	if u == user && p == password {
		return true
	}
	return false
}

func EmptyUserPass(u, p string) bool {
	return strings.Trim(u, " ") == "" || strings.Trim(p, " ") == ""
}
