;;; packages.el --- bj-javascript layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Bryan Joseph <bryanjos@bryanjos>
;; URL: https://github.com/bryanjos/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `bj-javascript-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `bj-javascript/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `bj-javascript/pre-init-PACKAGE' and/or
;;   `bj-javascript/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst bj-javascript-packages
  '(
    add-node-modules-path
    company-flow
    eslintd-fix
    flycheck
    rjsx-mode
    ))

(defun bj-javascript/init-eslintd-fix ()
  (use-package eslintd-fix
    :defer t
    :commands eslintd-fix-mode
    :init
    (add-hook 'rjsx-mode-hook #'eslintd-fix-mode)))

(defun bj-javascript/init-rjsx-mode ()
  (use-package rjsx-mode
    :defer t
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

      (setq
       js2-mode-show-strict-warnings nil
       js2-mode-show-parse-errors nil
       js-indent-level 2
       js2-basic-offset 2
       js2-strict-trailing-comma-warning nil
       js2-strict-missing-semi-warning nil)

      (add-hook 'rjsx-mode-hook #'bj-javascript/eslintd-set-flycheck-executable))
    :config
    (modify-syntax-entry ?_ "w" js2-mode-syntax-table)))

(defun bj-javascript/init-add-node-modules-path ()
  (use-package add-node-modules-path
    :defer t
    :init
    (with-eval-after-load 'rjsx-mode
      (add-hook 'rjsx-mode-hook #'add-node-modules-path))))

(defun bj-javascript/post-init-company-flow ()
  (spacemacs|add-company-backends
   :backends
   '((company-flow :with company-dabbrev-code)
     company-files)))

(defun bj-javascript/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (push 'javascript-jshint flycheck-disabled-checkers)
    (push 'json-jsonlint flycheck-disabled-checkers))

  (spacemacs/add-flycheck-hook 'rjsx-mode))
;;; packages.el ends here
