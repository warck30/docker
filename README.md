# docker
## **Репозиторий  с  заданием  для  курса  "Docker"**

> *Цель работы – создать Dockerfile для раздельной сборки софта и для создания контейнера, где этот софт дальше будет запускаться.*

## Ход работы:

 1. Этап 1. Сборка c++ приложения
 2. Этап 2. Сборка go приложения
 3. Этап 3. Объединение в единый образ
 
 ### Описание проекта.
 
Реализована многоэтапная сборка приложения в едином Dockerfile
При запуске контейнера появляется окно выбора желаемого приложения 
 
 ### 1. C++ приложение.
 
 В качестве нашей программы на C++ будет простой Хеллоу Ворлд
 ```cpp
#include  <iostream>
  
int  main() {
std::cout << "Hello from C++!" << std::endl;
return  0;
}
 ```
 
Для компиляции бинарного файла используем образ gcc:10.3

```Dockerfile
FROM  gcc:10.3  AS  builder_cpp

WORKDIR  /src

COPY  cpp-app/main.cpp  . 

RUN  g++  -o  cpp_app  main.cpp  -static
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
Для компиляции бинарного файла используем образ golang:1.18

```Dockerfile
FROM golang:1.18 AS builder_go

WORKDIR /src

COPY go-app/main.go .

RUN go build -o go_app main.go
```

### 3. Итоговая сборка

Сборка финального образа

```Dockerfile
FROM alpine:3.20

WORKDIR /app

COPY --from=builder_cpp /src/cpp_app /app/

COPY --from=builder_go /src/go_app /app/

ENTRYPOINT ["sh", "-c"]

CMD ["echo 'Выберите приложение: cpp или go' && \
	read APP && \
	if [ \"$APP\" = \"cpp\" ]; \
	then exec /app/cpp_app; \
	elif [ \"$APP\" = \"go\" ]; \
	then exec /app/go_app; \
	else echo 'Неверный выбор'; fi"]
```

Сборка нашего образа выполним командой

```sh
# docker build -t [image_name] .
```

### 4. Запускаем Hello-World

Для запуска нашего контейнера выполним команду

```sh
# docker run --rm --name [container_name] [image_name]
```

В итоге, в терминале отобразится предложение ввода:

```sh
Выберите приложение: cpp или go
```
В зависимости от выбора вывод будет: 

> Hello from C++!

или

> Hello from Go!
---


> P.S.
> Работа протестирована на виртуальных машинах с AL CE 2.12 и AL SE 1.7.X