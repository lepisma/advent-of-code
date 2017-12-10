;; Advent of code day 10

(ql:quickload :alexandria)
(ql:quickload :cl-ppcre)

(defun repeat (sequence times)
  (apply #'concatenate 'list (make-list times :initial-element sequence)))

(defun reverse-subseq (sequence from len &optional (at 0))
  (if (= at (floor len 2)) sequence
      (let ((x (mod (+ from at) (length sequence)))
            (y (mod (- (+ from len) (+ at 1)) (length sequence))))
        (rotatef (nth x sequence) (nth y sequence))
        (reverse-subseq sequence from len (+ at 1)))))

(defun reduce-slice (sequence slice-size func &optional acc)
  (if (null sequence) (nreverse acc)
      (reduce-slice (nthcdr slice-size sequence) slice-size func
                    (cons (apply func (subseq sequence 0 slice-size)) acc))))

(defun update-numbers (numbers lengths &optional (pos 0) (skip 0))
  (if (null lengths) (values numbers pos skip)
      (update-numbers (reverse-subseq numbers pos (car lengths))
                      (cdr lengths) (+ pos (car lengths) skip) (+ skip 1))))

;; Part one
(let* ((lengths (mapcar #'parse-integer
                        (cl-ppcre:split "," (alexandria:read-file-into-string "input.txt"))))
       (numbers (alexandria:iota 256 :start 0))
       (results (update-numbers numbers lengths)))
  (* (car results) (cadr results)))

;; Part two
(let* ((lengths (concatenate 'list
                             (butlast (map 'list #'identity (alexandria:read-file-into-byte-vector "input.txt")))
                             '(17 31 73 47 23)))
       (numbers (alexandria:iota 256 :start 0))
       (results (update-numbers numbers (repeat lengths 64))))
  (format nil "~{~(~A~)~}"
          (mapcar (lambda (x) (write-to-string x :base 16))
                  (reduce-slice results 16 #'logxor))))
