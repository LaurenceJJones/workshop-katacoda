package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

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
	router.ForwardedByClientIP = true
	router.LoadHTMLGlob("templates/*.html")
	f, err := os.OpenFile("/var/log/myapp.log", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	log.SetOutput(f)
	log.SetFlags(0)
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
				formatLog(c, "provided empty username or password")
				c.HTML(http.StatusBadRequest, "index.html", gin.H{"content": "Parameters can't be empty"})
				return
			}

			if !CheckUserPass(u, p) {
				formatLog(c, fmt.Sprintf("invalid login request USER=(%s)", u))
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
			if user == nil {
				formatLog(c, fmt.Sprintf("unauthorized request URI=(%s)", c.Request.RequestURI))
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
	router.NoRoute(func(c *gin.Context) {
		formatLog(c, fmt.Sprintf("resource not found URI=(%s)", c.Request.RequestURI))
		c.Redirect(301, "/")
	})
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

func formatLog(c *gin.Context, s string) {
	log.Printf("%s %s %s", time.Now().Format(time.RFC3339), "10.10.10.10", s)
}
