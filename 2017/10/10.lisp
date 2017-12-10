;; Advent of code day 10

(ql:quickload :alexandria)
(ql:quickload :cl-ppcre)

(defun repeat (sequence times)
  (apply #'concatenate 'list (make-list times :initial-element sequence)))

(defun arange (limit)
  (make-array limit :initial-contents (alexandria:iota limit :start 0)))

(defun reverse-subarray (array from len &optional (at 0))
  (if (= at (floor len 2)) array
      (let ((x (mod (+ from at) (length array)))
            (y (mod (- (+ from len) (+ at 1)) (length array))))
        (rotatef (aref array x) (aref array y))
        (reverse-subarray array from len (+ at 1)))))

(defun reduce-slice (sequence slice-size func &optional acc)
  (if (= (length sequence) 0) (nreverse acc)
      (reduce-slice (subseq sequence slice-size) slice-size func
                    (cons (apply func (nthcdr slice-size sequence)) acc))))

(defun update-array (array lengths &optional (pos 0) (skip 0))
  (if (null lengths) array
      (update-array (reverse-subarray array pos (car lengths))
                    (cdr lengths) (+ pos (car lengths) skip) (+ skip 1))))

;; Part one
(let* ((lengths (mapcar #'parse-integer
                        (cl-ppcre:split "," (alexandria:read-file-into-string "input.txt"))))
       (numbers (arange 256))
       (results (update-array numbers lengths)))
  (* (aref results 0) (aref results 1)))

;; Part two
(let* ((lengths (concatenate 'list
                             (butlast (map 'list #'identity (alexandria:read-file-into-byte-vector "input.txt")))
                             '(17 31 73 47 23)))
       (numbers (arange 256))
       (results (update-array numbers (repeat lengths 64))))
  (format nil "~{~(~A~)~}"
          (mapcar (lambda (x) (write-to-string x :base 16))
                  (reduce-slice (map 'list #'identity results) 16 #'logxor))))
