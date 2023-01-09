package main

import (
	"flag"
	"net/http"
	"strings"

	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/cookie"

	"github.com/gin-gonic/gin"
)

var password, user string

var randomKey = []byte("sup3rs3cr3t")

func main() {
	flag.StringVar(&user, "user", "user", "User arg")
	flag.StringVar(&password, "password", "password", "Password arg")
	flag.Parse()
	router := gin.Default()
	router.LoadHTMLGlob("templates/*.html")

	router.Use(sessions.Sessions("session", cookie.NewStore(randomKey)))

	i := router.Group("/")
	{
		i.GET("/", LoginGetHandler())
		i.POST("/", LoginPostHandler())
	}

	router.Run("0.0.0.0:3000")
}

func LoginPostHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		user := session.Get(randomKey)
		if user != nil {
			c.HTML(http.StatusBadRequest, "login.html", gin.H{"content": "Please logout first"})
			return
		}

		u := c.PostForm("username")
		p := c.PostForm("password")

		if EmptyUserPass(u, p) {
			c.HTML(http.StatusBadRequest, "index.html", gin.H{"content": "Parameters can't be empty"})
			return
		}

		if CheckUserPass(u, p) {
			c.HTML(http.StatusUnauthorized, "index.html", gin.H{"content": "Incorrect username or password"})
			return
		}

		session.Set(randomKey, u)
		if err := session.Save(); err != nil {
			c.HTML(http.StatusInternalServerError, "index.html", gin.H{"content": "Failed to save session"})
			return
		}

		//c.Redirect(http.StatusMovedPermanently, "/dashboard")
	}
}

func LoginGetHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		user := session.Get(randomKey)
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
	}
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
