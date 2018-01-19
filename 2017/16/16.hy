#!/usr/bin/env hy

(import [collections [deque]])
(import [tqdm [trange]])

(defn read-commands [file-name]
  (with [fp (open file-name)]
    (.split (.strip (fp.read)) ",")))

(defn swap-indices [items i j]
  (setv [(get items i) (get items j)]
        [(get items j) (get items i)]))

(defn swap-values [items a b]
  (swap-indices items (.index items a) (.index items b)))

(defn execute-command [command items]
  (setv fc (first command))
  (setv rst (cut command 1))
  (if (= fc "s")
      (.rotate items (int rst))
      (do (setv [x y] (.split rst "/"))
          (cond [(= fc "x") (swap-indices items (int x) (int y))]
                [(= fc "p") (swap-values items x y)]))))

(defmain [&rest args]
  (setv commands (read-commands "input.txt"))
  (setv chars "abcdefghijklmnop")
  (setv items (deque chars))
  (setv limit 1000000000)
  (setv i 0)
  (while (< i limit)
    (for [cmd commands] (execute-command cmd items))
    (setv i (inc i))
    (setv items-str (.join "" items))
    (if (= i 1)
        (print (+ "Part one: " items-str)))
    (if (= chars items-str)
        (setv i (* i (// limit i)))))
  (print (+ "Part two: " items-str)))
