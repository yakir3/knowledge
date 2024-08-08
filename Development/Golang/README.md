### Install
```bash
# Download and Install
# https://go.dev/doc/install

# Managing Go installations
# https://go.dev/doc/manage-install

# Installing from source
# https://go.dev/doc/install/source
```


### Goland
```bash
# active code
ideaActive


# plugins
# themes
gradianto
# json show
rainbow brackets

```


### Learning
#### Formatting
```go
fmt.Print()
fmt.Println()
fmt.Printf()

```

#### Commentary
```go
package main
import "fmt"

func main() {
    fmt.Println("hello world!") // Oneline comment
    /*
        Multi-line Comments 1
        Multi-line Comments 2
    */
}
```

#### Names
##### Package names
```go

```

##### Getters
```go

```

##### Interface names
```go

```

##### MixedCaps
```go

```

#### Control structures
##### If
```go

```

##### Redeclaration and reassignment
```go

```

##### For
```go
var names [3]int = [3]int{1,2,3}
var names = [...]string{"a","b","c"}
for k,v := range names {
    fmt.Println(k,v)
}
```

##### Switch
```go

```

##### Type switch
```go

```

#### Functions
##### Multiple return values
##### Named result parameters
##### Defer

#### Data
##### Allocation with new
```go
var p *int = new(int)
fmt.Println(*p)
```

##### Constructors and composite literals

##### Allocation with make
```go
var s []int = make([]int, 3, 5)
//var s []string = make([]string, 3, 5)
fmt.Println(s)
```


##### Arrays
```go
var arr [3]int8 = [3]int8{1,2,3}
//var arr [3]int = [3]int{1,2,3}
fmt.Printf("%p\n", &arr)
fmt.Println(&arr[0])
fmt.Println(&arr[1])
fmt.Println(&arr[2])
```

##### Slices
##### Two-dimensional slices

##### Maps

##### Printing

##### Append
```go

```

#### Initialization
##### Constants
##### Variables
##### The init function

#### Methods
##### Pointers vs. Values
```go
var x int = 10
fmt.Printf("%p\n", &x)
var p *int = &x
fmt.Printf("%p\n", &p)
fmt.Println(p)
fmt.Println(*p)
```

#### Interfaces and other types
##### Interfaces
##### Conversions
##### Interface conversions and type assertions
##### Generality
##### Interfaces and methods


>Reference:
>1. [Official Document](https://go.dev)
>2. [Golang Github](https://github.com/golang/go)
>3. [Go语言中文网](https://studygolang.com/dl)
