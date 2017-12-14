;; Advent of code day 14
(ql:quickload '(:alexandria :serapeum))

(defparameter *input-string* (string-trim '(#\Newline) (alexandria:read-file-into-string "input.txt")))
(defparameter *size* 128)

(defun repeat (sequence times)
  (apply #'concatenate 'list (make-list times :initial-element sequence)))

(defun arange (limit)
  (make-array limit :initial-contents (alexandria:iota limit :start 0)))

(defun reverse-subarray (array from len)
  (let ((array (alexandria:rotate array (- from)))
        (slice (subseq array 0 len)))
    (setf (subseq array 0 len) (nreverse slice))
    (alexandria:rotate array from)))

(defun update-array (array lengths &optional (pos 0) (skip 0))
  (if (null lengths) array
      (update-array (reverse-subarray array pos (car lengths))
                    (cdr lengths) (+ pos (car lengths) skip) (+ skip 1))))

(defun knot-hash (input)
  (let* ((lengths `(,@(map 'list #'char-code input) 17 31 73 47 23))
         (numbers (arange 256))
         (results (update-array numbers (repeat lengths 64))))
    (format nil "~{~(~2,'0x~)~}" (mapcar (lambda (slice) (reduce #'logxor slice)) (serapeum:batches results 16)))))

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
