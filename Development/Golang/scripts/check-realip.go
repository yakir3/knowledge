/*
@Time    : 2024-05
@Author  : Yakir
@File    : check-realip.go
*/
package main

import (
    //"bytes"
    "crypto/tls"
    "encoding/json"
    "log"
    "io"
    "net/http"
    "net/smtp"
    "os"
    "reflect"
    "strings"
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
    //logFile   *os.File
)
func init() {
    //logFile, err := os.OpenFile("./all.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
    //if err != nil {
    //    panic("Error creating or open log file")
    //}
    //dlogger = log.New(logFile, "Log: ", log.Ldate|log.Ltime|log.Lshortfile)
    //dlogger = log.New(io.MultiWriter(os.Stdout, logFile), "Log: ", log.Ldate|log.Ltime|log.Lshortfile)
    dlogger = log.New(os.Stdout, "", log.Ldate|log.Ltime|log.Lshortfile)
}

//func getCloudflare() {
//
//}

func getCloudfront() {
    // 定义 cloudfront 接口地址以及发起 http 请求
    cfURL := "https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips"
    resp, err := http.Get(cfURL)
    if err != nil {
        dlogger.Fatal("Error request to cloudfront api:", err)
    }
    defer resp.Body.Close()

    // 解析 response body 反序列化为 map 对象,合并 IP 数组为 cloudfront 切片 newSlice
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        dlogger.Fatal("Error reading response:", err)
    }
    var respData = make(map[string][]string)
    if err := json.Unmarshal(body, &respData); err != nil {
        dlogger.Fatal("Error decoding JSON:", err)
    }
    var newSlice = make([]string, 0)
    newSlice = append(append(newSlice, respData["CLOUDFRONT_GLOBAL_IP_LIST"]...), respData["CLOUDFRONT_REGIONAL_EDGE_IP_LIST"]...)

    // 已读写方式打开 realip.json 文件
    file, err := os.OpenFile("./realip.json", os.O_CREATE|os.O_RDWR, 0644)
    if err != nil {
        dlogger.Fatal("Error creating or open file:", err)
    }
    defer file.Close()
    oldContent := make([]byte, 10240)
    n, err := file.Read(oldContent)
    if err != nil {
        dlogger.Fatal("Error reading file:", err)
    }
    oldContentStr := string(oldContent[:n])

    // 初始化 RealipData 结构体, 将文件内容序列化为结构体数据类型, 获取 cloudfront 数据切片 oldSlice
    var realipData RealipData
    if err := json.Unmarshal([]byte(oldContentStr), &realipData); err != nil {
        dlogger.Fatal("Error decoding JSON:", err)
    }
    //dlogger.Println(realipData)
    oldSlice := realipData.Cloudfront

    // 对比 oldSlice 与 newSlice 切片是否有差值. 有差值: 发出通知邮件, 邮件发送成功更新接口内容到文件中
    var diff = diffSlice(oldSlice, newSlice)
    if len(diff) == 0 {
        dlogger.Println("AWS Cloudfront Realip No Update.")
    } else {
        // 发送通知邮件
        sd := "Notice<notice@example.com>"
        rcv := "Yakir<yakir@example.com>"
        sbj := "AWS Cloudfront Realip Update Notification"
        msg := strings.Join(diff, "\n")
        //sendEmail(sd, rcv, sbj, msg)
        dlogger.Println(sd, rcv, sbj, reflect.TypeOf(msg))

        // 新切片数据 newSlice 写回 RealipData 结构体
        realipData.Cloudfront = newSlice
        realipDataByte, err := json.Marshal(realipData)
        if err != nil {
            dlogger.Println("Error encoding JSON:", err)
        }
        dlogger.Println(reflect.TypeOf(realipDataByte))

        // 结构体数据 realipData 回写文件 real.json
        // option1: os.File WriteAt
        //if _, err = file.WriteAt(realipDataByte, 0); err != nil {
        //    dlogger.Println("Error writing data:", err)
        //}
        // option2: io.WriterAt WriteAt
        //writer := io.WriterAt(file)
        //if _, err = writer.WriteAt(realipDataByte, 0); err != nil {
        //    dlogger.Println("Error writing data:", err)
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

// 发送邮件函数
func sendEmail(sd, rcv, sbj, msg string) {
    // Set up authentication information.
    from := sd
    //password := ""
    smtpHost := "172.22.1.21"
    smtpPort := "25"
    //auth := smtp.PlainAuth("", from, password, smtpHost)

    // Connect to the server, authenticate, set the sender and recipient,
    // and send the email all in one step.
    to := []string{rcv}
    subject := sbj
    message := []byte("To: " + to[0] + "\r\n" +
                  "Subject: " + subject + "\r\n" +
                  "\r\n" +
                  msg + "\r\n")

    // SMTP Client
    conn, err := smtp.Dial(smtpHost + ":" + smtpPort)
    if err != nil {
        dlogger.Println("Error connecting to SMTP server:", err)
        return
    }
    defer conn.Close()
    // STARTTLS: Disable TLS verification
    tlsConfig := &tls.Config{
        InsecureSkipVerify: true,
    }
    if ok, _ := conn.Extension("STARTTLS"); ok {
        if err := conn.StartTLS(tlsConfig); err != nil {
            dlogger.Println("Error starting TLS:", err)
            return
        }
    }
    //// Auth
    //if err := conn.Auth(auth); err != nil {
    //    dlogger.Println("Error authenticating:", err)
    //    return
    //}

    // Send mail
    if err := conn.Mail(from); err != nil {
        dlogger.Println("Error setting from address:", err)
        return
    }
    if err := conn.Rcpt(to[0]); err != nil {
        dlogger.Println("Error adding recipient:", err)
        return
    }
    w, err := conn.Data()
    if err != nil {
        dlogger.Println("Error starting data:", err)
        return
    }
    _, err = w.Write(message)
    if err != nil {
        dlogger.Println("Error writing message:", err)
        return
    }
    err = w.Close()
    if err != nil {
        dlogger.Println("Error closing data:", err)
        return
    }
    dlogger.Println("Email sent successfully!")

    return
}

func main() {
    //defer logFile.Close()

    //getCloudflare()
    getCloudfront()
}
