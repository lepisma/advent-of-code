;; Day 2

(ql:quickload :cl-ppcre)

(defun tokenize (line)
  "Return sorted integers"
  (sort (mapcar #'parse-integer (cl-ppcre:split #\Tab line)) #'<))

(defun row-diff (tokens)
  "Map row for part 1"
  (- (car (last tokens)) (car tokens)))

(defun row-match-item (item rst)
  (reduce #'+
          (remove-if-not #'integerp (mapcar (lambda (x) (/ x item)) rst))))

(defun row-divide (tokens &optional (res 0))
  "Map row for part 2"
  (if (null tokens)
      res
      (row-divide (cdr tokens)
                  (+ res (row-match-item (car tokens) (cdr tokens))))))

(defun find-checksum (lines row-func)
  (apply #'+ (mapcar (lambda (line) (funcall row-func (tokenize line))) lines)))

;; Solution
(with-open-file (stream #p"./input.txt")
  (let ((lines (loop for line = (read-line stream nil)
                     while line collect line)))
    (values
     (find-checksum lines #'row-diff)
     (find-checksum lines #'row-divide))))
