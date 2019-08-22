package main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func Test_indexHandler(t *testing.T) {
	w := httptest.NewRecorder()
	c, router := gin.CreateTestContext(w)

	router.LoadHTMLGlob("templates/*")

	c.Request, _ = http.NewRequest("GET", "/", nil)
	indexHandler(c)

	assert.Equal(t, 200, w.Result().StatusCode)
}
