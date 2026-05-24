;;; curl — HTTP client library for Lum Lisp
;;; https://github.com/lum-lisp/curl
;;;
;;; Usage:
;;;   (import "curl")
;;;   (curl/get "https://api.example.com")
;;;
;;; Requires: curl CLI installed on the system.

(define curl/last-status 0)
(define curl/last-headers "")

(define (curl/build-args method data headers)
  (define cmd "curl -sL")
  (set! cmd (string-append cmd " -w \"\\n---S:%{http_code}\\n---H:%{header_json}\""))

  (if (not (string=? method "GET"))
    (set! cmd (string-append cmd " -X " method)))

  (if (not (string=? data ""))
    (set! cmd (string-append cmd " -d '" data "'")))

  (define (iter hdrs)
    (if (not (null? hdrs))
      (begin
        (set! cmd (string-append cmd " -H '" (car hdrs) "'"))
        (iter (cdr hdrs)))))

  (iter headers)
  cmd)

(define (curl/parse-response output)
  (define parts (string-split output "\n---S:"))

  (if (> (length parts) 1)
    (begin
      (define body (car parts))
      (define rest (car (cdr parts)))
      (define status-parts (string-split rest "\n---H:"))

      (define status-str
        (if (> (length status-parts) 1)
          (string-trim (car status-parts))
          (string-trim (car status-parts))))

      (define header-str
        (if (> (length status-parts) 1)
          (string-trim (car (cdr status-parts)))
          ""))

      (set! curl/last-status (string->number status-str))
      (set! curl/last-headers header-str)
      body)

    (begin
      (set! curl/last-status 0)
      (set! curl/last-headers "")
      output)))

(define (curl/exec method url data headers)
  (curl/parse-response
    (shell->string
      (string-append (curl/build-args method data headers) " '" url "'"))))

;; Public API

(define (curl/get url)
  (curl/exec "GET" url "" ()))

(define (curl/get-with-headers url headers)
  (curl/exec "GET" url "" headers))

(define (curl/post url data)
  (curl/exec "POST" url data ()))

(define (curl/post-with-headers url data headers)
  (curl/exec "POST" url data headers))

(define (curl/put url data)
  (curl/exec "PUT" url data ()))

(define (curl/put-with-headers url data headers)
  (curl/exec "PUT" url data headers))

(define (curl/patch url data)
  (curl/exec "PATCH" url data ()))

(define (curl/patch-with-headers url data headers)
  (curl/exec "PATCH" url data headers))

(define (curl/delete url)
  (curl/exec "DELETE" url "" ()))

(define (curl/delete-with-data url data)
  (curl/exec "DELETE" url data ()))

(define (curl/delete-with-headers url headers)
  (curl/exec "DELETE" url "" headers))

(define (curl/head url)
  (curl/parse-response
    (shell->string
      (string-append "curl -sL -w \"\\n---S:%{http_code}\" --head '" url "'"))))

(define (curl/options url)
  (curl/exec "OPTIONS" url "" ()))

(define (curl/status)
  curl/last-status)

(define (curl/response-headers)
  curl/last-headers)
