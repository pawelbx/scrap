(read-jq-filter)

(defvar jq-filter-active nil
  "active filtering")

(defun read-jq-filter()
  (let ((jq-filter-active :live))
    (read-from-minibuffer "JQ Filter: ")))


(defun live-jq-filter()
  (let ((jq-filter (minibuffer-contents-no-properties)))
    (set-buffer "*jq-results*")
    (erase-buffer)
    (set-buffer "*jq-buffer-results*")
    (call-process-region (point-min) (point-max) "jq" nil "*jq-results*" nil jq-filter)))

(defun setup-minibuffer-for-jq-filtering()
  (when (eq :live jq-filter-active)
    (add-hook 'post-command-hook 'live-jq-filter nil :local)))

(add-hook 'minibuffer-setup-hook 'setup-minibuffer-for-jq-filtering)
