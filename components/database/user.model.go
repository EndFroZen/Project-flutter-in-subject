package database

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserInfo struct {
	gorm.Model
	Name     string
	Email    string `gorm:unique`
	Password string
	Phone    string
}

func Register(db *gorm.DB, user *UserInfo) error {
	hashedpassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedpassword)
	result := db.Create(user)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func Login(db *gorm.DB, user *UserInfo) (string, error) {
	Auser := new(UserInfo)
	KEY := os.Getenv("KEY")
	result := db.Where("email = ?", user.Email).First(Auser)
	if result.Error != nil {
		return "", result.Error
	}
	err := bcrypt.CompareHashAndPassword([]byte(Auser.Password), []byte(user.Password))
	if err != nil {
		return "", err
	}
	secretKey := []byte(KEY)
	claims := &jwt.RegisteredClaims{
		Issuer:    Auser.Email,
		ExpiresAt: jwt.NewNumericDate(time.Now().Add((7 * 24) * time.Hour)),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(secretKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func GetUserByEmail(db *gorm.DB, email string) (*UserInfo, error) {
	var user UserInfo
	result := db.Where("email = ?", email).First(&user)
	if result.Error != nil {
		return nil, result.Error
	}
	return &user, nil
}
