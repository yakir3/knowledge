/*
@Time    : 2024-05
@Author  : Yakir
@File    : check-realip.go
*/
package main

import (
    //"fmt"
    "encoding/json"
    "log"
    "io"
    "net/http"
    "os"
    //"reflect"
)

type RealipData struct {
    Cloudflare []string `json:"cloudflare"`
    Cloudfront []string `json:"cloudfront"`
}

// log config
var (
    dlogger   *log.Logger
    //Info      *log.Logger
    //Error     *log.Logger
    logFile   *os.File
)
func init() {
    logFile, err := os.OpenFile("./all.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
    if err != nil {
        panic("Error creating or open log file")
    }
    dlogger = log.New(os.Stdout, "Log: ", log.Ldate|log.Ltime|log.Lshortfile)
    //dlogger = log.New(logFile, "Log: ", log.Ldate|log.Ltime|log.Lshortfile)
    //dlogger = log.New(io.MultiWriter(os.Stdout, logFile), "Log: ", log.Ldate|log.Ltime|log.Lshortfile)
}

//func getCloudflare() {
//
//}

func getCloudfront() {
    dlogger.Println(logFile)
    defer logFile.Close()

    // 定义 cloudfront 接口地址以及发起 http 请求
    cfURL := "https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips"
    resp, err := http.Get(cfURL)
    if err != nil {
        dlogger.Fatal("Error request to cloudfront api:", err)
        return
    }
    defer resp.Body.Close()

    // 解析 response body 反序列化为 map 对象,合并 IP 数组为 cloudfront 切片 newSlice
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        dlogger.Fatal("Error reading response:", err)
        return
    }
    var respData = make(map[string][]string)
    if err := json.Unmarshal(body, &respData); err != nil {
        dlogger.Fatal("Error decoding JSON:", err)
        return
    }
    var newSlice = make([]string, 0)
    newSlice = append(append(newSlice, respData["CLOUDFRONT_GLOBAL_IP_LIST"]...), respData["CLOUDFRONT_REGIONAL_EDGE_IP_LIST"]...)

    // 已读写方式打开 realip.json 文件
    file, err := os.OpenFile("./realip.json", os.O_CREATE|os.O_RDWR, 0644)
    if err != nil {
        dlogger.Println("Error creating or open file:", err)
        return
    }
    defer file.Close()
    oldContent := make([]byte, 10240)
    n, err := file.Read(oldContent)
    if err != nil {
        dlogger.Println("Error reading file:", err)
        return
    }
    oldContentStr := string(oldContent[:n])

    // 初始化 RealipData 结构体, 将文件内容序列化为结构体数据类型, 获取 cloudfront 数据切片 oldSlice
    var realipData RealipData
    if err := json.Unmarshal([]byte(oldContentStr), &realipData); err != nil {
        dlogger.Println("Error decoding JSON:", err)
        return
    }
    //dlogger.Println(realipData)
    oldSlice := realipData.Cloudfront

    // 对比 oldSlice 与 newSlice 切片是否有差值. 有差值: 发出通知邮件, 邮件发送成功更新接口内容到文件中
    var diff = diffSlice(oldSlice, newSlice)
    if len(diff) == 0 {
        dlogger.Println("AWS Cloudfront RealIP 无更新.")
    } else {
        dlogger.Println(len(diff))
        // 发送通知邮件
        // sendEmail()
        //log.Fatal(err)

        // 新切片数据 newSlice 写回 RealipData 结构体
        realipData.Cloudfront = newSlice
        realipDataByte, err := json.Marshal(realipData)
        if err != nil {
            dlogger.Println("Error encoding JSON:", err)
        }

        dlogger.Println(realipDataByte)

        // 结构体数据 realipData 回写文件 real.json
        /*
        // option1: io.WriteString
        //if _, err := io.WriteString(file, string(realipDataByte)); err != nil {
        //    dlogger.Println("Error writing file:", err)
        //}
        /*
        // option2: file.WriteAt
        //_, err = file.WriteAt(realipDataByte, 0)
        //if err != nil {
        //    dlogger.Println("Error writing file:", err)
        //    return
        //}
    }

    return
}

// 对比两个切片的差值函数
func diffSlice(oslice, nslice []string) []string {
    diff := make([]string, 0)

    // 创建一个 map 用于存储标识 oslice 中的元素
    m := make(map[string]bool)
    for _, item := range oslice {
        m[item] = true
    }

    // 检查 nslice 中的元素是否在 map 中，如果不在则添加到差值切片中
    for _, item := range nslice {
        if _, ok := m[item]; !ok {
            diff = append(diff, item)
        }
    }

    return diff
}

func main() {
    //getCloudflare()
    getCloudfront()
}
