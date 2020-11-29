(* generated by Ott 0.31, locally-nameless from: stlc.ott *)
Require Import Bool.
Require Import Metalib.Metatheory.
Require Import List.
Require Import Ott.ott_list_core.
(** syntax *)
Definition tvar : Set := var. (*r term variable *)
Definition Tvar : Set := var. (*r type variable *)

Inductive type : Set :=  (*r type *)
 | type_int : type (*r int *)
 | type_top : type (*r top *)
 | type_arrow (A:type) (B:type) (*r function *).

Inductive term : Set :=  (*r term *)
 | term_int : term (*r int *)
 | term_var_b (_:nat) (*r variable *)
 | term_var_f (x:tvar) (*r variable *)
 | term_abs (e:term) (*r abstraction *)
 | term_app (e1:term) (e2:term) (*r application *)
 | term_annotation (e:term) (A:type) (*r type annotation *).

(* EXPERIMENTAL *)
(** auxiliary functions on the new list types *)
(** library functions *)
(** subrules *)
(** arities *)
(** opening up abstractions *)
Fixpoint open_term_wrt_term_rec (k:nat) (e_5:term) (e__6:term) {struct e__6}: term :=
  match e__6 with
  | term_int => term_int 
  | (term_var_b nat) => if (k === nat) then e_5 else (term_var_b nat)
  | (term_var_f x) => term_var_f x
  | (term_abs e) => term_abs (open_term_wrt_term_rec (S k) e_5 e)
  | (term_app e1 e2) => term_app (open_term_wrt_term_rec k e_5 e1) (open_term_wrt_term_rec k e_5 e2)
  | (term_annotation e A) => term_annotation (open_term_wrt_term_rec k e_5 e) A
end.

Definition open_term_wrt_term e_5 e__6 := open_term_wrt_term_rec 0 e__6 e_5.

(** terms are locally-closed pre-terms *)
(** definitions *)

(* defns LC_term *)
Inductive lc_term : term -> Prop :=    (* defn lc_term *)
 | lc_term_int : 
     (lc_term term_int)
 | lc_term_var_f : forall (x:tvar),
     (lc_term (term_var_f x))
 | lc_term_abs : forall (L:vars) (e:term),
      ( forall x , x \notin  L  -> lc_term  ( open_term_wrt_term e (term_var_f x) )  )  ->
     (lc_term (term_abs e))
 | lc_term_app : forall (e1 e2:term),
     (lc_term e1) ->
     (lc_term e2) ->
     (lc_term (term_app e1 e2))
 | lc_term_annotation : forall (e:term) (A:type),
     (lc_term e) ->
     (lc_term (term_annotation e A)).
(** free variables *)
(** substitutions *)

(** definitions *)

(* defns subtyping *)
Inductive sub : type -> type -> Prop :=    (* defn sub *)
 | sub_S_Int :
     sub type_int type_int
 | sub_S_Top : forall (A:type),
     sub A type_top
 | sub_S_Arrow : forall (A B C D:type),
     sub C A ->
     sub B D ->
     sub (type_arrow A B) (type_arrow C D).


(** infrastructure *)
Hint Constructors sub lc_term : core.

Theorem sub_transitivity:
  forall t2 t1 t3, sub t1 t2 -> sub t2 t3 -> sub t1 t3.
Proof.
  induction t2; intros.
  - induction t1; eauto.
    inversion H.
    inversion H.
  - induction t1; auto.
    inversion H0.
    constructor.
    induction t3.
    inversion H0.
    constructor.
    inversion H0.
  - generalize dependent t1.
    generalize dependent t3.
    induction t1; intros.
    + inversion H.
    + inversion H.
    + induction t3; subst.
      * inversion H0.
      * constructor.
      * inversion H0; subst.
        inversion H; subst.
        constructor.
        apply IHt2_1 with (t1:=t3_1) (t3:=t1_1) in H4.
        assumption.
        assumption.
        apply IHt2_2 with (t1:=t1_2) (t3:=t3_2) in H8.
        assumption.
        assumption.
Qed.
