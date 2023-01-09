package main

import (
	"flag"

	"github.com/gin-gonic/gin"
)

var password, user string

func main() {
	flag.StringVar(&user, "user", "user", "User arg")
	flag.StringVar(&password, "password", "password", "Password arg")
	flag.Parse()
	router := gin.Default()
	router.LoadHTMLGlob("templates/*.html")

	index := router.Group("/")
	{
		index.GET("/", func(ctx *gin.Context) {
			ctx.HTML(200, "index.html", gin.H{})
		})
	}

	router.Run("0.0.0.0:3000")
}
