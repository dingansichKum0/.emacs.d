;;; Code:


;; js2-mode: enhanced JavaScript editing mode
(use-package js2-mode
  :mode (("\\.js$" . js2-mode))
  :config
  (setq js-indent-level 2
        js2-basic-offset 2
        js-chain-indent t)
  (setq js2-highlight-level 3)
  (setq js2-mode-show-parse-errors t)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-strict-missing-semi-warning nil))


;; typescript: major mode for editing typescript files
(use-package typescript-mode
  :config 
  (setq typescript-indent-level 2))


;; format
(use-package prettier-js
  :init
  (setq prettier-js-args '("--single-quote" "true" "--print-width" "120"))
  :hook
  (js2-mode . prettier-js-mode)
  (typescript-mode . prettier-js-mode)
  (web-mode . prettier-js-mode))



(provide 'init-js)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-js.el ends here
