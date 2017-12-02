;; Day 1. Captcha
(defun add-numbers (s-num offset &optional (acc 0) (current-idx 0))
  "Solve the problem with string number."
  (if (< current-idx (length s-num))
      (let ((f (char s-num current-idx))
            (s (char s-num (mod (+ current-idx offset) (length s-num)))))
        (add-numbers s-num offset (if (char-equal f s) (+ (digit-char-p f) acc) acc) (+ current-idx 1)))
      acc))

;; Solution
(with-open-file (stream "./input.txt")
  (let ((input (read-line stream nil)))
    (values
     (add-numbers input 1)
     (add-numbers input (/ (length input) 2)))))
