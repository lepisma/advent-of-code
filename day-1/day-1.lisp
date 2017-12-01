;; Advent of code 2017 day 1

(defun add-numbers (s-num offset &optional (acc 0))
  "Solve the problem with string number."
  (if (>= (- (length s-num) offset) 1)
      (let* ((f (char s-num 0))
             (s (char s-num offset))
             (next (subseq s-num 1)))
        (if (char-equal f s)
            (add-numbers next offset (+ (digit-char-p f) acc))
            (add-numbers next offset acc)))
      acc))

(defun pad-around (input padding)
  "Create a circularly padded version on input."
  (values (concatenate 'string input (subseq input 0 padding)) padding))

(with-open-file (stream "./input.txt")
  (let ((input (read-line stream nil)))
    (values
     (multiple-value-bind (s-num padding) (pad-around input 1)
       (add-numbers s-num padding))
     (multiple-value-bind (s-num padding) (pad-around input (/ (length input) 2))
       (add-numbers s-num padding)))))
