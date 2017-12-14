#lang racket

(require racket/match)

(define [read-input]
  (call-with-input-file "input.txt"
    (lambda [in]
      (string-split (read-line in) ","))))

(define [find-distance pos]
  (match pos
    [(cons X Y) (/ (+ (abs X) (abs Y) (abs (+ X Y))) 2)]))

(define [move steps [pos '(0 . 0)] [history '()]]
  (if (null? steps)
      (cons pos history)
      (match pos
        [(cons X Y)
         (let [[new-pos (case (car steps)
                          [("n")  (cons X (+ Y 1))]
                          [("nw") (cons (- X 1) (+ Y 1))]
                          [("ne") (cons (+ X 1) Y)]
                          [("s")  (cons X (- Y 1))]
                          [("se") (cons (+ X 1) (- Y 1))]
                          [("sw") (cons (- X 1) Y)])]]
           (move (cdr steps) new-pos (cons pos history)))])))

(let [[results (move (read-input))]]
  (fprintf (current-output-port)
           "Part one: ~a\nPart two: ~a"
           (find-distance (car results))
           (apply max (map find-distance (cdr results)))))
