package main

import (
	"flag"
	"fmt"

	"github.com/gin-gonic/gin"
)

func main() {
	var password string
	flag.StringVar(&password, "password", "", "Password arg")
	flag.Parse()
	router := gin.Default()
	fmt.Println(password)
	router.LoadHTMLGlob("templates/*.html")

	index := router.Group("/")
	{
		index.GET("/", func(ctx *gin.Context) {
			ctx.HTML(200, "index.html", gin.H{})
		})
	}

	router.Run("0.0.0.0:3000")
}
