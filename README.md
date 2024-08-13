# docker
## **Репозиторий  с  заданием  для  курса  "Docker"**

> *Цель работы – создвть Dockerfile для раздельной сборки софта и для создания контейнера, где этот софт дальше будет запускаться.*

## Ход работы:

 1. Написание Dockerfile для сборки C++ приложения.
 2. Написание Dockerfile для сборки Go приложения.
 3. Написание Dockerfile для финального образа, который позволяет выбирать запускаемое приложение.
 
 ### 1. C++ приложение.
 
 В качестве нашей программы на C++ будет простой Хеллоу Ворлд
 ```cpp
#include  <iostream>
  
int  main() {
std::cout << "Hello from C++!" << std::endl;
return  0;
}
 ```
 
Для сборки приложения напишем Dockerfile
Для сборки используем образ gcc:10.3 и alpine для запуска бинарника.

```Dockerfile
FROM gcc:10.3 as builder

WORKDIR /app

COPY main.cpp .

RUN g++ -o cpp_app main.cpp -static

FROM alpine:3.20

COPY --from=builder /app/cpp_app /usr/local/bin/cpp_app

CMD ["cpp_app"]
```

Билдим образ C++ программы
```sh
# docker build -t cpp-app -f cpp-app/Dockerfile cpp-app/
```

### 2. Go приложение.

Go приложение - тоже Хеллоу Ворлд
```go
package main
import  "fmt"
 
func  main() {
fmt.Println("Hello from Go!")
}
```

Напишем Dockerfile для сборки программы.
Для сборки используем образ golang:1.18 и alpine для запуска бинарника.

```Dockerfile
FROM  golang:1.18  as  builder

WORKDIR  /app

COPY  main.go  .

RUN  go  build  -o  go_app  main.go

FROM  alpine:3.20

COPY  --from=builder  /app/go_app  /usr/local/bin/go_app

CMD  ["go_app"]
```

Билдим образ Go программы
```sh
# docker build -t go-app -f go-app/Dockerfile go-app/
```
### 3. Сборка финального образа

Сборка финального образа

```Dockerfile
FROM  alpine:3.20

COPY  --from=cpp-app  /usr/local/bin/cpp_app  /usr/local/bin/cpp_app

COPY  --from=go-app  /usr/local/bin/go_app  /usr/local/bin/go_app

ENTRYPOINT  []
```
После сборки вторичных образов соберем главный образ

```sh
# docker build -t combined-app .
```

### 4. Запускаем Hello-World

Для запуска наших бинарей в контейнере выполним команду

```sh
# docker run --rm combined-app /usr/local/bin/cpp_app
# docker run --rm combined-app /usr/local/bin/go_app
```

В итоге, в терминале отобразится вывод программы в зависимости от нашего вывода.

> Hello from C++!
> Hello from Go!
---


> P.S.
> Работа протестирована на виртуальных машинах с AL CE 2.12 и AL SE 1.7.X