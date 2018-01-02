;; Advent of code 2017 day 07
(require 'f)
(require 'ht)
(require 's)
(require 'dash)
(require 'dash-functional)

(defvar 07-progs nil
  "Global var for keeping progs")

(defvar 07-weights (ht-create)
  "Total weights for nodes")

(defun 07-process-line (line)
  "Process a LINE in a cons of name and another cons with info"
  (let ((name (->> line (s-split "(") (car) (s-trim)))
        (w (->> line
              (s-split "(") (second)
              (s-split ")") (car)
              (string-to-number)))
        (holds (let ((branching (s-split "->" line)))
                 (if (> (length branching) 1)
                     (->> branching (second)
                        (s-split ",")
                        (-map #'s-trim))
                   nil))))
    (cons name (cons w holds))))

(defun 07-read-input (file-name)
  "Read input into a hash"
  (let ((lines (->> (s-split "\n" (f-read-text file-name))
                  (-remove (-cut string-equal "" <>)))))
    (setq 07-progs (ht<-alist (-map #'07-process-line lines)))))

(defun 07-weigh (name)
  "Return total weight for name"
  (if (ht-contains? 07-weights name)
      (ht-get 07-weights name)
    (let* ((node (ht-get 07-progs name))
           (weight (+ (car node)
                      (-reduce #'+ (-map #'07-weigh (cdr node))))))
      (ht-set! 07-weights name weight)
      weight)))

(defun 07-different? (values)
  "Tell if values are different"
  (< 1 (length (-uniq values))))

(defun 07-find-unbalanced (names)
  "Return the one unbalanced node"
  (let ((uname))
    (--each names
      (let* ((node (ht-get 07-progs it))
             (weights (-map #'07-weigh (cdr node))))
        (if (and (not (null weights))
                 (07-different? weights)
                 (or (null uname)
                     (>= (07-weigh uname) (07-weigh it))))
            (setq uname it))))
    uname))

(defun 07-separate-deviant (uname)
  "Return a list of children nodes with deviant at the first position"
  (let* ((children (cdr (ht-get 07-progs uname)))
         (sorted (--sort (> (07-weigh it) (07-weigh other)) children)))
    (if (= (07-weigh (car sorted)) (07-weigh (nth 1 sorted)))
        (reverse sorted)
      sorted)))

(defun 07-part-one ()
  "Return solution for part one"
  (--max-by (> (07-weigh it) (07-weigh other)) (ht-keys 07-progs)))

(defun 07-part-two ()
  "Return solution for part two"
  (let* ((uname (07-find-unbalanced (ht-keys 07-progs)))
         (children (07-separate-deviant uname))
         (deviant (car children))
         (normal (cadr children)))
    (+ (car (ht-get 07-progs deviant))
       (- (07-weigh normal)
          (07-weigh deviant)))))

(07-read-input "input.txt")
(print (07-part-one))
(print (07-part-two))
