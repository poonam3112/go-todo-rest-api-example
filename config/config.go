package config

import(
	"os"




    "github.com/joho/godotenv"
)
type Config struct {
	DB *DBConfig
}

type DBConfig struct {
	Dialect  string
	Host     string
	Port     int
	Username string
	Password string
	Name     string
	Charset  string
}

// func GetConfig() *Config {
// 	return &Config{
// 		DB: &DBConfig{
// 			Dialect: "mysql",
// 			// Host:     "host.docker.internal",
// 			Host:     os.Getenv("DB_HOST"),
// 			Port:     3306,
// 			Username: os.Getenv("DB_USER"),
// 			Password: os.Getenv("DB_PASS"),
// 			Name:     os.Getenv("DB_NAME"),
// 			Charset:  "utf8",
// 		},
// 	}
// }

func GetConfig() *Config {
	var abc = os.Getenv("DB_USER")
	errEnv := godotenv.Load()

    if errEnv != nil {

        panic("Failed to load env file")

    }
	println(abc)
	return &Config{
		DB: &DBConfig{
			Dialect: "mysql",
			Host:    "host.docker.internal",
			Port:     3306,
			Username: "root",
			Password: "",
			Name:     "todoapp",
			Charset:  "utf8",
		},
	}
	
}
