(define curl/last-status 0)
(define curl/last-headers "")

(define (curl/build-args method data headers)
  (define cmd "curl -sL")
  (set! cmd (string-append cmd " -w \"\\n---S:%{http_code}\\n---H:%{header_json}\""))

  (if (not (string=? method "GET"))
    (set! cmd (string-append cmd " -X " method)))

  (if (not (string=? data ""))
    (set! cmd (string-append cmd " -d '" data "'")))

  (define (add-headers hdrs)
    (if (not (null? hdrs))
      (begin
        (set! cmd (string-append cmd " -H '" (car hdrs) "'"))
        (add-headers (cdr hdrs)))))

  (add-headers headers)
  cmd)

(define (curl/parse-response output)
  (define body output)
  (define status-str "")
  (define header-str "")

  (define parts (string-split output "\n---S:"))

  (if (> (length parts) 1)
    (begin
      (set! body (car parts))
      (define rest (car (cdr parts)))
      (define status-parts (string-split rest "\n---H:"))

      (if (> (length status-parts) 1)
        (begin
          (set! status-str (string-trim (car status-parts)))
          (set! header-str (string-trim (car (cdr status-parts)))))
        (begin
          (set! status-str (string-trim (car status-parts)))
          (set! header-str "")))

      (set! curl/last-status (string->number status-str))
      (set! curl/last-headers header-str)
      body)
    (begin
      (set! curl/last-status 0)
      (set! curl/last-headers "")
      output)))

(define (curl/request method url)
  (curl/parse-response
    (shell->string
      (string-append (curl/build-args method "" ()) " '" url "'"))))

(define (curl/request-with-data method url data)
  (curl/parse-response
    (shell->string
      (string-append (curl/build-args method data ()) " '" url "'"))))

(define (curl/request-with-headers method url headers)
  (curl/parse-response
    (shell->string
      (string-append (curl/build-args method "" headers) " '" url "'"))))

(define (curl/request-with-data-and-headers method url data headers)
  (curl/parse-response
    (shell->string
      (string-append (curl/build-args method data headers) " '" url "'"))))

(define (curl/get url)
  (curl/request "GET" url))

(define (curl/get-with-headers url headers)
  (curl/request-with-headers "GET" url headers))

(define (curl/post url data)
  (curl/request-with-data "POST" url data))

(define (curl/post-with-headers url data headers)
  (curl/request-with-data-and-headers "POST" url data headers))

(define (curl/put url data)
  (curl/request-with-data "PUT" url data))

(define (curl/put-with-headers url data headers)
  (curl/request-with-data-and-headers "PUT" url data headers))

(define (curl/patch url data)
  (curl/request-with-data "PATCH" url data))

(define (curl/patch-with-headers url data headers)
  (curl/request-with-data-and-headers "PATCH" url data headers))

(define (curl/delete url)
  (curl/request "DELETE" url))

(define (curl/delete-with-data url data)
  (curl/request-with-data "DELETE" url data))

(define (curl/delete-with-headers url headers)
  (curl/request-with-headers "DELETE" url headers))

(define (curl/head url)
  (curl/parse-response
    (shell->string
      (string-append "curl -sL -w \"\\n---S:%{http_code}\" --head '" url "'"))))

(define (curl/options url)
  (curl/request "OPTIONS" url))

(define (curl/status)
  curl/last-status)

(define (curl/response-headers)
  curl/last-headers)
