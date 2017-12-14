;; Advent of code day 10
(ql:quickload '(:alexandria :serapeum))

(load #p"./knot-hash.lisp")

(defparameter *input-string* (string-trim '(#\Newline) (alexandria:read-file-into-string #p"./input.txt")))

;; Part one
(let* ((lengths (mapcar #'parse-integer (serapeum:split-sequence #\, *input-string*)))
       (numbers (arange 256))
       (results (update-array numbers lengths)))
  (* (aref results 0) (aref results 1)))

;; Part two
(knot-hash *input-string*)
