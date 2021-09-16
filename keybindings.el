;;; keybindings.el -*- lexical-binding: t; -*-

;; ---------------------------------------
;; Emacs
;; ---------------------------------------
(map! :map global-map
      :leader
      :desc "Toggle frame maximized"
      :nv "tm" #'toggle-frame-maximized)

(map! :map emacs-lisp-mode-map
      :localleader
      :desc "Eval defun at point"
      :nv "ef" #'eros-eval-defun)

(map! :leader
      :desc "Narrow or widen dwim"
      :nv "zz" #'my/narrow-or-widen-dwim)

(map! :leader
      :desc "Search for symbol at point in current project"
      :nv "*" #'my/search-project-for-symbol-at-point)

(map! :map global-map
      :leader
      :desc "Add buffer to persp"
      :nv "ba" #'my/add-current-buffer-to-persp)

(map! :map global-map
      :desc "cycle-spacing"
      "M-SPC" 'cycle-spacing)

(map! :n "j" #'evil-next-visual-line
      :n "k" #'evil-previous-visual-line)

(map! :map org-mode-map
      :localleader
      :desc "Org ctrl-c-ctrl-c"
      :n "," #'org-ctrl-c-ctrl-c)

;; ---------------------------------------
;; Clojure
;; ---------------------------------------
(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Eval defun at point"
      :nv "ef" #'cider-eval-defun-at-point)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Eval defun at point"
      :nv "ef" #'cider-eval-defun-at-point)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Format defn"
      :nv "ff" #'cider-format-defun)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Format buffer"
      :nv "fb" #'cider-format-buffer)

;; ---------------------------------------
;; Forms
;; ---------------------------------------
(map! :after with-editor
      :map with-editor-mode-map
      :localleader
      :nv "," #'with-editor-finish)

(map! :after with-editor
      :map with-editor-mode-map
      :localleader
      :nv "a" #'with-editor-cancel)

;; ---------------------------------------
;; Dired
;; ---------------------------------------
(map! :after dired
      :map dired-mode-map
      :leader
      :desc "Dired jump"
      :nv "fj" #'dired-jump)
