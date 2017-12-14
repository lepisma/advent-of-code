;; Advent of code day 14
(ql:quickload '(:alexandria))

(load #p"../10/knot-hash.lisp")

(defparameter *input-string* (string-trim '(#\Newline) (alexandria:read-file-into-string "input.txt")))
(defparameter *size* 128)

(defun row-hash (row-idx)
  (format nil "~{~4,'0b~}" (map 'list (lambda (c) (parse-integer (string c) :radix 16))
                                (knot-hash (format nil "~A-~A" *input-string* row-idx)))))

(defun disk-hash ()
  (mapcar #'row-hash (alexandria:iota *size*)))

(defun position-used? (pos disk-hash)
  (eq #\1 (char (nth (car pos) disk-hash) (cdr pos))))

(defun remove-visited (new-positions visited-positions)
  (remove-if (lambda (p) (member p visited-positions :test #'tree-equal)) new-positions))

(defun all-used-positions (disk-hash &optional (pos '(0 . 0)) positions)
  "Return all used positions as cons cells."
  (if (and (= (car pos) (- *size* 1)) (= (cdr pos) (- *size* 1)))
      positions
      (let ((posn (if (= (cdr pos) (- *size* 1)) `(,(+ (car pos) 1) . 0) `(,(car pos) . ,(+ (cdr pos) 1)))))
        (all-used-positions disk-hash posn (if (position-used? pos disk-hash) (cons pos positions) positions)))))

(defun get-neighbours (pos)
  (let* ((x (car pos))
         (y (cdr pos))
         (neighbours `((,(+ x 1) . ,y) (,(- x 1) . ,y) (,x . ,(+ y 1)) (,x . ,(- y 1)))))
    (remove-if (lambda (pos)
                 (let ((x (car pos))
                       (y (cdr pos)))
                   (or (or (>= x *size*) (>= y *size*)) (or (< x 0) (< y 0)))))
               neighbours)))

(defun get-connected-neighbours (positions disk-hash &optional visited)
  "Return recursively used neighbours for positions. Assume positions themselves are used."
  (let* ((neighbours (apply #'append (mapcar
                                      (lambda (pos) (remove-if-not (lambda (n) (position-used? n disk-hash)) (get-neighbours pos)))
                                      positions)))
         (new-neighbours (remove-visited neighbours (append positions visited))))
    (if (null new-neighbours)
        visited
        (get-connected-neighbours new-neighbours disk-hash (append new-neighbours visited)))))

(defun find-connected-regions (all-positions disk-hash &optional (ans 0))
  (if (null all-positions)
      ans
      (let* ((current (pop all-positions))
             (new-nodes (get-connected-neighbours `(,current) disk-hash)))
        (find-connected-regions (remove-visited all-positions new-nodes) disk-hash (+ ans 1)))))

;; Part one
(reduce #'+ (mapcar (lambda (row-hash) (reduce #'+ (map 'list (lambda (c) (parse-integer (string c))) row-hash))) (disk-hash)))

;; Part two
(let* ((disk-hash (disk-hash))
       (positions (all-used-positions disk-hash)))
  (find-connected-regions positions disk-hash))
