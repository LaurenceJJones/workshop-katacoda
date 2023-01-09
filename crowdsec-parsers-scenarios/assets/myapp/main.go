package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.LoadHTMLGlob("templates/*.html")

	index := router.Group("/")
	{
		index.GET("/", func(ctx *gin.Context) {
			ctx.HTML(200, "index.html", gin.H{})
		})
	}

	router.Run("localhost:3000")
}
