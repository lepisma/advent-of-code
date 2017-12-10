;; Advent of code day 10
(ql:quickload '(:alexandria :serapeum))

(defparameter *input-string* (string-trim '(#\Newline) (alexandria:read-file-into-string "input.txt")))

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

(defun update-array (array lengths &optional (pos 0) (skip 0))
  (if (null lengths) array
      (update-array (reverse-subarray array pos (car lengths))
                    (cdr lengths) (+ pos (car lengths) skip) (+ skip 1))))

;; Part one
(let* ((lengths (mapcar #'parse-integer (serapeum:split-sequence #\, *input-string*)))
       (numbers (arange 256))
       (results (update-array numbers lengths)))
  (* (aref results 0) (aref results 1)))

;; Part two
(let* ((lengths `(,@(map 'list #'char-code *input-string*) 17 31 73 47 23))
       (numbers (arange 256))
       (results (update-array numbers (repeat lengths 64))))
  (format nil "~{~(~2,'0x~)~}" (mapcar (lambda (slice) (reduce #'logxor slice)) (serapeum:batches results 16))))
