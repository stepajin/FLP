(defvar C nil)
(defvar S nil)
(defvar Q nil)
(defvar casenumber 1)
(defvar row nil)
(defvar col nil)
(defvar var nil)
(defvar graph nil)

(defun readCSQ ()
	(setf C (read))
	(setf S (read))
	(setf Q (read))
)

(defun floyd-warshall ()
	(loop for k from 0 to (- C 1) do 
		(loop for i from 0 to (- C 1) do
			(loop for j from 0 to (- C 1) do
				(setf (aref graph i j) (min (aref graph i j) (max (aref graph i k) (aref graph k j))))
			)	
		)
	)
)

(defun loadGraph ()
	(setf graph (make-array '(100 100) :initial-element most-positive-fixnum))
	(loop for i from 0 to (- S 1) do
		(setf row (- (read) 1))
		(setf col (- (read) 1))
		(setf val (read))
		(setf (aref graph row col) val)
		(setf (aref graph col row) val)
	) 
)

(defun queries ()
	(if (> casenumber 1)
		(format t "~%")
	)

	(format t "Case #~D~%" casenumber)

	(loop for i from 0 to (- Q 1) do
		(setf val (aref graph (- (read) 1) (- (read) 1)))
		(if (< val most-positive-fixnum)
			(format t "~D~%" val)
			(format t "no path~%" val)
		)
	)
)

(loop
	(readCSQ)
	(if (eq C 0) (return))
	(loadGraph)
	(floyd-warshall)
	(queries)
	(setf casenumber (+ casenumber 1))
)