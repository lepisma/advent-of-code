(require 's)
(require 'f)
(require 'dash)
(require 'dash-functional)

(defun 12-read-pairs ()
  (let ((lines (->> "./input.txt"
                  (f-read-text)
                  (s-split "\n")
                  (-remove (-cut s-equals? "" <>)))))
    (-map (-cut s-split "<->" <>) lines)))

(defun 12-write-pairs ()
  (let ((pairs (12-read-pairs))
        (outlines '()))
    (--each pairs
      (let ((targets (s-split "," (second it))))
        (-each targets
          (lambda (target) (push (format "edge(%s, %s)." (car it) target) outlines)))))
    (f-write-text (s-join "\n" outlines) 'utf-8 "./input.pl")))

(12-write-pairs)
