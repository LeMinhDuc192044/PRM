Published as a conference paper at ICLR 2024
LabelDP-Pro: LEARNING WITH LABEL DIFFERENTIAL
PRIVACY VIA PROJECTIONS
Badih Ghazi
Google Research
Yangsibo Huang∗
Princeton University
Pritish Kamath
Google Research
Ravi Kumar
Google Research
Pasin Manurangsi
Google Research
Chiyuan Zhang
Google Research
ABSTRACT
Label differentially private (label DP) algorithms seek to preserve the privacy
of the labels in a training dataset in settings where the features are known
to the adversary.
In this work, we study a new family of label DP training
algorithms.
Unlike most prior label DP algorithms that have been based on
label randomization, our algorithm naturally leverages the power of the central
model of DP. It interleaves gradient projection operations with private stochastic
gradient descent steps in order to improve the utility of the trained model while
guaranteeing the privacy of the labels.
We show that such projection-based
algorithms can be made practical and that they improve on the state-of-the-art
for label DP training in the high-privacy regime. We complement our empirical
evaluation with theoretical results shedding light on the efficacy of our method
through the lens of bias-variance trade-offs.
1
INTRODUCTION
DP-SGD Gradient
Non-Private Gradient
Projected Gradient
Projection Subspace
Figure 1:
LabelDP-Pro denoises the DP-SGD
gradient via projection. Since the signal (non-private
gradient) is already in the subspace, the projection
essentially reduces the additive DP-SGD noise. The
green dashed (resp., blue dotted) line shows the
gradient noise before (resp., after) projection.
Differential privacy (DP) (Dwork et al., 2006b;a),
which introduces calibrated noise into machine
learning pipelines, has emerged as a fundamental
tool for safeguarding the privacy of user data.
This formal and robust framework, governed by a
privacy parameter ε (see Definition 1), is widely
used in private machine learning applications.
In machine learning, the vanilla definition of DP
aims to protect both the features and labels of the
training examples. However, this can be an overkill in settings where the sensitivity lies solely in
the labels of the training examples. A notable example is in the realm of online advertising (Cheng
et al., 2016; Wang et al., 2017; Guo et al., 2017; Zhou et al., 2018; Naumov et al., 2019; Wang et al.,
2021). Here, the primary objective is to predict whether a user will perform a useful action on the
advertiser website (e.g., purchase the advertised product) after interacting with an advertisement on
another (the publisher’s) website, a task inherently involving private and sensitive labels. This
prediction is made based on features consisting of the product description associated with the
displayed advertisement, which are generally considered non-private. 1
The notion of label differential privacy (LabelDP), introduced by Chaudhuri & Hsu (2011), captures
such use cases by leveraging the standard definition of DP to only protect the privacy of the labels.
There has been a growing interest in studying label-only privacy in deep learning (e.g., Ghazi
et al. (2021); Malek et al. (2021); Esfandiari et al. (2022); Tang et al. (2022)). Many of these
∗Work done while interning at Google Research.
1We point out that several new privacy-preserving APIs for ad measurement that were proposed by different
web browsers support training ad prediction models with label DP. These include APIs from Mozilla and Meta
(Thomson, 2022), Google Chrome (Nalpas & White, 2021), and Apple Safari (app).
1
Published as a conference paper at ICLR 2024
mechanisms rely on variants of the classic randomized response algorithm (Warner, 1965). In such
mechanisms, each label is randomly changed to a (potentially) different label according to a pre-
defined probability distribution. The training is then conducted with the randomized labels, which
ensures LabelDP.
In this paper, we focus on the high-privacy regime (with a small privacy parameter ε). This regime
is especially important where highly sensitive data are being processed, as the privacy guarantee
becomes exponentially loose with large ε. Additionally, small ε is also essential for user-level
privacy where the privacy budget is shared by multiple examples of each user. Therefore, small ε
is generally desired in private learning when possible. However, achieving LabelDP in the high-
privacy regime presents a unique challenge.
The crux of the issue lies in the fact that in the
high-privacy regime, the signal-to-noise ratio is extremely low in the privatized labels generated
by randomized response. This problem is encountered by all LabelDP mechanisms that are based
on randomized response and its variants.
On the other hand, we notice that DP-SGD (Abadi et al., 2016), a standard method for training deep
networks with DP guarantees, exhibits better noise scaling in the high-privacy regime, compared to
mechanisms relying on randomized response. However, DP-SGD guarantees privacy for both the
features and the labels, which is overly stringent for the LabelDP setting. Therefore, to fully harness
the advantage of DP-SGD’s noise scaling, we study LabelDP-Pro, a family of methods that tailor
DP-SGD to unlock better utility in the high-privacy regime by applying projection operations.
Our main contributions are summarized as follows:
• We present LabelDP-Pro to adapt DP-SGD for LabelDP settings with a projection-based
Denoiser. This Denoiser leverages the public input features in LabelDP to counteract the over-
killing noise associated with full (i.e., features and labels) DP protection in DP-SGD (Section 3).
• We show an efficient method for computing the projections via advanced autodiff (Section 3.2).
• Our LabelDP-Pro is the first practical method that fully utilizes the flexibility of the LabelDP
definition, the central DP setting, and the approximate-DP guarantee. In contrast, all LabelDP
mechanisms based on randomized response operate in the local DP setting and are restricted to
offer pure-DP guarantees, resulting in poor utility in high-privacy regimes.
• Through empirical evaluations on four benchmark datasets, we show that LabelDP-Pro improves
the state-of-the-art for LabelDP training in the high-privacy regime (Section 5).
• We extend our investigation to user-level DP, which ensures the privacy of all examples
contributed by each user, and demonstrate using a real-world dataset for which LabelDP-Pro
offers a consistent improvement over previous LabelDP baselines (Section 6).
• Complementing our empirical findings, we also provide theoretical analyses that justify the
choice of the Denoiser and explain the observed improvements (Section 4).
2
LEARNING WITH LABEL DIFFERENTIAL PRIVACY
Let D be an unknown distribution on X × Y. We consider the multi-class classification setting
where Y = [K] := {1, . . . , K}. In supervised learning, we have a training set D of n examples
drawn i.i.d. from D. The goal is to learn a predictor fθ : X →RK to minimize the expected loss
LD(fθ) := E(x,y)∼Dℓ(fθ(x), y), for some loss function ℓ: RK × Y →R; the most common loss
function for multi-class classification is the cross entropy loss ℓ(v, y) = −log vy. With an abuse of
notation, we also use ℓ(θ, (x, y)) to denote the per-example loss ℓ(fθ(x), y).
2.1
(LABEL) DIFFERENTIAL PRIVACY
We recall the definition of DP; for more background, see the book of Dwork & Roth (2014b).
Definition 1 (DP; Dwork et al. (2006b)). Let ε ∈R>0, δ ∈[0, 1). A randomized algorithm A is said
to be (ε, δ)-differentially private (denoted (ε, δ)-DP) if for any two adjacent input datasets (differ
by at most one datapoint) D and D′, and any subset S of outputs of A, it holds that Pr[A(D) ∈
S] ≤eε · Pr[A(D′) ∈S] + δ.
In supervised learning, a learning algorithm produces a model as its output, while the labeled training
set serves as its input. Two training datasets are “adjacent” if they differ on a single training example.
This notion of adjacency protects the privacy of both the features and the label of any individual
2
Published as a conference paper at ICLR 2024
Algorithm 1: LabelDP-Pro
Input : Initial model weights θ0, a training set D of size n, learning rate ηt, number of
training iterations T, batch size n1, noise multiplier σ, gradient norm bound C, and
Denoiser, which is a method for denoising gradients.
Output: The trained model weights θT .
1 for t = 0 to T −1 do
2
Get a mini-batch IG
t of n1 indices by uniform sampling from [n]
3
foreach i ∈IG
t do gt(xi, yi) ←∇θtℓ(θt, (xi, yi))
// Compute gradient
4
foreach i ∈IG
t do ¯gt(xi, yi) ←gt(xi, yi)/ max
 1, ∥gt(xi,yi)∥2
C

// Clip gradient
5
˜gt ←
1
n1
P
i∈IG
t ¯gt(xi, yi) + N(0, σ2C2I)

// Aggregate and add noise
6
ˆgt ←Denoiser (˜gt, θt, {xi}i∈IG
t )
// De-noise the gradient
7
θt+1 ←θt −ηtˆgt
// Optimize; can also use other optimizers
example. However, in certain scenarios, protecting the features may be unnecessary or infeasible,
and the focus is solely on protecting the privacy of the labels. This leads to the following notion:
Definition 2 (LabelDP; Chaudhuri & Hsu (2011)). A randomized training algorithm A is (ε, δ)-
LabelDP if it is (ε, δ)-DP when two input datasets differ on the label of a single training example.
For both notions, due to the eε factor, the high-privacy regime corresponds to small ε (e.g., ε < 1).
Item-level and user-level DP
In the traditional notion of DP, the goal is to protect the privacy of
each training example, where it is assumed that each user contributed only one training example; this
is commonly known as item-level or example-level privacy. However, in scenarios where a single
user contributes multiple training examples, a more desirable objective would be the so-called user-
level privacy, which ensures the privacy of all examples contributed by one user. In this case, the
“adjacent” dataset would differ on all the examples from a single user. This is especially relevant
in applications such as online advertising and federated learning, where each user often contributes
multiple examples (McMahan et al., 2017; Liu et al., 2020; Levy et al., 2021).
2.2
RANDOMIZED RESPONSE AND DP-SGD
Randomized response (RR) (Warner, 1965), which precedes the advent of DP, has been used as a
standard mechanism to provide LabelDP guarantees. Let y ∈[K] be the ground truth label. When
an observer queries the value of y, RR with ε-LabelDP responds with a random draw ˜y ∈[K].
Specifically, RR returns the ground truth label y with a probability of
eε
eε+K−1, while with the
remaining probability, it returns a uniformly random element from [K]\{y}.
DP-SGD was proposed in the seminal paper by Abadi et al. (2016), and has become the most widely
adopted algorithm for privately training deep neural networks. DP-SGD works by clipping the
per-example gradient and adding Gaussian noises, during each training iteration. (For a formal
description, see Algorithm 1 with a NOOP denoiser.) DP-SGD relies on the fact that only a random
mini-batch of examples are processed in each iteration, and uses amplification by sampling (Abadi
et al., 2016; Bassily et al., 2014; Wang et al., 2018) to drive down the overall privacy cost.
3
LabelDP-Pro
As discussed above, RR-based LabelDP mechanisms flip the labels with probability
K−1
eε+K−1; thus,
in the high-privacy regime, incur exponentially more noise. For instance, with K = 10 and ε = 0.5,
in expectation more than 84% of the training labels would be incorrect. In contrast, the scale
of the Gaussian noise in DP-SGD increases only linearly with 1/ε in the high-privacy regime.
The suboptimal noise scaling for RR is partly because it provides a more stringent local privacy
guarantee, compared to the central privacy guarantee discussed here (See Appendix B for more
details). Inspired by this, we propose LabelDP-Pro, a novel approach that enjoys the flexibility
of both central privacy (improved noise scaling) and the LabelDP (auxiliary information computed
from the input features) to unlock high utility of LabelDP in the high-privacy (i.e., small ε) regime.
3
Published as a conference paper at ICLR 2024
Table 1: A summary of denoisers for noisy gradients ˜gt, with optional access to the model weights θt and
the features of the current batch :{xi}i∈IG
t . A denoiser can also access the features of the full training set.
In particular, it can sample an “alternative” batch IP
t of n2 examples and have access to {xi}i∈IP
t . The last
column indicates if the denoiser is compatible with amplification by subsampling in the privacy accounting.
Denoiser
Output
Compatible with Amp.
NOOP
˜gt
Yes
SELFSPAN
ProjA(˜gt) for A = span

{∇θtℓ(θt, (xi, κ)}i∈IG
t ,κ∈[K]

No
SELFCONV
ProjA(˜gt) for A = conv

{∇θtℓ(θt, (xi, κ)}i∈IG
t ,κ∈[K]

No
ALTCONV
ProjA(˜gt) for A = conv

{∇θtℓ(θt, (xi, κ)}i∈IP
t ,κ∈[K]

Yes
3.1
PROJECTION-BASED GRADIENT DENOISING
Due to better noise scaling, DP-SGD could achieve better utility than classical algorithms like RR in
the high-privacy LabelDP regime. However, it would be an overkill as DP-SGD protects the privacy
of both features and labels. In the following, we propose a framework to improve DP-SGD by using
the input features, which yields a family of new algorithms that enjoys the same linear noise scaling,
and outperforms DP-SGD (and RR) in the high-privacy LabelDP regime.
The main idea is that structural priors can be computed based on the input features, and
utilized to denoise the noisy gradient from DP-SGD. Specifically, the framework introduces a
Denoiser function, described in Algorithm 1 (vanilla DP-SGD is thus a special case with a NOOP
denoiser.).
Table 1 summarizes some useful denoisers.
For example, the SELFSPAN denoiser
makes use of the fact that the (original unnoised) gradient lies in the span of the per-example per-
class gradients {∇θtℓ(θt, (xi, κ)}i∈IG
t ,κ∈[K]. So it denoises the private gradient from DP-SGD
by projecting it onto this span.
Note the span can be constructed using only the features and
without accessing the labels—the denoising step thus crucially exploits the LabelDP setting! As an
alternative view, note that the privatized gradient in DP-SGD is the sum of the signal (the gradient)
and the Gaussian noise. The SELFSPAN projection for the signal part is a no-op because the signal
is already in the span. As a result, the denoising step is essentially reducing the noise by projecting
it onto a lower dimensional subspace while keeping the signal intact (Figure 1).
Taking one step further, note that the unnoised gradient is not just in the span, but also in the convex
hull of the per-example per-class gradients. This observation leads to the SELFCONV denoiser,
which has an improved dependency on K (Table 4). Moreover, we can also independently sample an
“alternative” batch IP
t of n2 examples and project onto its gradients {∇θtℓ(θt, (xi, κ)}i∈IP
t ,κ∈[K],
again using only the public information; we call this denoiser ALTCONV. Empirically, we found
that both SELFCONV and ALTCONV behave quite similarly under the same DP-SGD noise (see
Table 3), but the latter has the extra benefit of being amenable to amplification by subsampling,
resulting in lower privacy cost. We defer to Section 3.4 for the details on the privacy accounting.
Unless otherwise specified, we will use the ALTCONV denoiser in the experiments.
3.2
MEMORY-EFFICIENT PROJECTION VIA ADVANCED AUTODIFF
The denoisers (Table 1) operate by projecting the noisy gradient onto the subspace or the convex
hull spanned by a set of per-example per-class gradients. A naive implementation of such projection
would need n2Kd memory to store the vertices spanning the convex hull, where d is the model size.
We next describe a memory-efficient algorithm.
Let ˜g be the privatized gradient, and G =
[∇θℓ(θ, (xi, κ))]i∈IP ,κ∈[K] be the d × n2K dimensional matrix of the per-example per-class
gradients (in the case of SELFSPAN and SELFCONV, IP = IG and n2 = n1). To project ˜g onto
the convex hull of the columns of G, we solve minα∈∆∥Gα −˜g∥2, where ∆is the unit simplex
for n2K-dimensional vectors. We solve this optimization problem with projective gradient descent.
Specifically, let α0 ∈∆be an initialization of the projection coefficients, and ηPGD be the step size,
we iteratively update it as αt+1 ←Proj∆

αt −2ηPGD G⊤(Gαt −˜g)

. The projection onto the
unit simplex can be computed using the methods of Wang & Carreira-Perpin´an (2013). We next
focus on efficiently computing the boxed red part, which depends on two subroutines: u 7→Gu
for any u ∈Rn2K, and v 7→G⊤v for any v ∈Rd. We note that given the special structure of G,
those subroutines can be computed using advanced auto differentiation (autodiff, Baydin et al., 2018)
primitives without materializing G. Indeed, define L : θ 7→[ℓ(θ, (xi, κ))]i∈[n2],κ∈[K] and observe
4
Published as a conference paper at ICLR 2024
that G⊤is the Jacobian of L. Then G⊤v is the Jacobian-vector product (JVP). It turns out that JVP
can be implemented via the forward mode autodiff, which cumulatively computes the results in a
“forward” manner from the bottom of the neural network, and does not require a materialization of
G. Similarly, the reverse mode autodiff can be used to compute the vector-Jacobian product (VJP)
in Gu = (u⊤G⊤)⊤; again, VJP does not need to materialize G. In fact, the reverse mode autodiff
is the default algorithm for computing the gradients in most deep learning frameworks, since the
back-propagation algorithm (Rumelhart et al., 1986) is a special case of it with a scalar loss. We
give a pseudocode implementation in Appendix C.
3.3
STABLE PROJECTION VIA COEFFICIENT SMOOTHING
Due to the noise in the privatized gradient, the projection coefficients α sometimes put dominating
values on an “incorrect” class. This might cause numerical instabilities in the learning dynamics due
to excessively large gradient norms (Figure 2) because of the unboundedness of the cross-entropy
loss, as also observed in previous work (Ghosh et al., 2017; Ma et al., 2020; Zhou et al., 2021).
In our case, we found a simple smoothing-based regularization to be effective. Specifically, we
create a smoothed projection coefficient ˜α = λα + (1 −λ)β, where β ∈Rn2K is a constant vector
with each coordinate being
1
K×n2 , representing a uniform distribution that assigns equal weights to
all projection vertices. λ controls the level of regularization, with smaller values indicating stronger
regularization. As depicted in Figure 2 and summarized in Table 2, enabling regularization (λ < 1)
leads to a more stable training process and improves utility. Typically, we find that a λ value of 0.75
yields the best results. Note if α is a one-hot encoded multi-class label, then this regularization is
akin to the label smoothing technique (M¨uller et al., 2019; Lukasik et al., 2020).
Figure 2: Effect of the regularization coefficient λ on the gradient norm
(left) and the training loss (right). Applying regularization with λ < 1
helps stabilize the training.
Table 2:
MNIST accuracy (%)
for
the
implementation
with
regularization
compared
to
the
vanilla implementation.
ε
Vanilla w/ Regularization
0.1
86.2
91.1
0.2
87.9
92.9
0.5
88.2
94.1
1.0
91.3
94.3
2.0
92.2
94.5
3.4
PRIVACY ANALYSIS
We recall the privacy analysis of DP-SGD (i.e., LabelDP-Pro with NOOP denoiser), and then show
that the same analysis also holds for LabelDP-Pro with ALTCONV denoiser. The privacy analysis
of DP-SGD is usually done by considering an approximation, where instead of shuffling and batch-
partitioning as generally done in practice, in each iteration, a batch is constructed by sampling
each example independently with probability n1/n. This enables analyzing the privacy cost of
DP-SGD via the composition of adaptively chosen Poisson subsampled Gaussian mechanisms,
which uses privacy amplification by subsampling to provide lower privacy cost. It is now easy
to see that applying the same approximation to LabelDP-Pro using ALTCONV denoiser is simply a
composition of adaptively chosen Poisson subsampled Gaussian mechanisms with post-processing,
hence we can apply the post-processing property of DP (Dwork & Roth, 2014a, Proposition 2.1).
The main thing to note about the ALTCONV denoiser is that the projection step involves sampling a
random subset IP
t from the training data to define the convex hull that the noisy gradient is projected
to. The analysis goes through since these are independent of the examples in the batch IG
t and do not
use the information about labels of examples in IP
t . Note that the same analysis does not hold when
using SELFSPAN or SELFCONV denoisers as the convex hull is defined by (unlabeled) examples in
IG
t , and so the final projected gradient might reveal information about IG
t (which examples ended
up being sampled in the current batch) and breaks privacy amplification by subsampling.
R´enyi Differential Privacy (RDP) accounting (Mironov, 2017) has been the most widely used
approach in DP-SGD (Abadi et al., 2016). Numerical approaches for obtaining tighter estimates
of privacy parameters have been studied recently using the notion of privacy loss distributions
(PLD) (Meiser & Mohammadi, 2018; Sommer et al., 2019), and several algorithms have been
5
Published as a conference paper at ICLR 2024
Table 3: Test accuracy (%) on the MNIST dataset with different denoisers.
“AMP.” stands for privacy
amplification via subsampling. The SELFSPAN and SELFCONV denoiser should not use amplification, and
the corresponding columns are shown (in gray) only for reference purposes.
ε
DP-SGD
Project onto span
Project onto convex hull
NOOP w/ AMP.
SELFSPAN w/o AMP.
SELFSPAN w/ AMP.
ALTCONV w/ AMP.
SELFCONV w/o AMP.
SELFCONV w/ AMP.
0.1
85.6
64.5
86.1
91.1
65.9
91.3
0.2
87.9
73.8
88.2
92.9
75.6
93.3
0.5
90.9
81.8
91.5
94.1
83.8
94.2
1.0
92.8
84.8
92.9
94.3
86.1
94.3
2.0
93.8
87.4
93.6
95.4
88.2
95.6
Table 4: Additional excess error due to privacy for PGD using stochastic gradient oracles.
Method
Additional excess error due to privacy
LabelDP-Pro: NOOP
O

RC
√
T ·
√
dσa
√n1

LabelDP-Pro: SELFSPAN
O

RC
√
T ·
√
Kσna

LabelDP-Pro: SELFCONV
O

RC

1
√n1 +
√σna 4√
log(Kn1)
4√n1

LabelDP-Pro: ALTCONV
O

RC

1
√n1 +
1
√n2 +
√σa 4√
log(Kn2)
4√n1

RR-Debiased (p =
K
eε+K−1)
O

RC
√
T ·
√p
(1−p)√n1

studied for the same (Koskela et al., 2020; Gopi et al., 2021; Ghazi et al., 2022; Doroshenko et al.,
2022). In particular, we use the privacy accounting implementation in Google’s DP Library (2020).
4
BOUNDS FOR CONVEX EMPIRICAL RISK MINIMIZATION
We now present our theoretical motivation that underlies the method presented in Algorithm 1 and
the denoisers presented in Table 1. We examine this through a case study of stochastic convex
optimization. Consider the goal of minimizing a convex objective L(w) for w ∈K, for some convex
set K with diameter R using a stochastic gradient oracle that, given w, returns a stochastic estimate
˜g(w) of g(w) := ∇L(w). The loss is said to be C-Lipschitz if ∥g(w)∥2 ≤C for all w. We say that
the gradient oracle has bias α and variance ω2 if ˜g(w) = g(w) + e(w) such that ∥E e(w)∥2 ≤α
and E ∥e(w) −E e(w)∥2
2 ≤ω2 holds for all w. Additionally, we say that the gradient oracle has
expected squared norm of eC2 if E ∥˜g(w)∥2 ≤eC2 for all w. The projected gradient descent (PGD)
with step size η is defined as iteratively performing wt+1 ←ProjK(wt −ηg(wt)), where ProjK(·)
is the projection onto K. Let w∗be a minimizer of L(w). The expected excess loss can be bounded
as shown below following the standard analysis of PGD (see, e.g., Hazan (2022)); we include a
proof for completeness in Appendix E.
Lemma 3. For a convex loss function L, and a gradient oracle with bias α and expected squared
norm eC2, PGD over a convex set K ⊆Rd with diameter R and step size η =
R
e
C
√
T achieves the
following expected excess risk bound for the average iterate ¯wT := 1
T
PT −1
t=0 wt:
E [L ( ¯wT )] −L(w∗) ≤R eC
√
T
+ αR.
(1)
Note that if L is C-Lipschitz and the gradient oracle has variance ω2, then eC2 ≤(C + α)2 + ω2,
although it is possible to get an improved upper bound on eC for some oracles we consider.
Now consider the problem of minimizing the empirical loss. Namely, let ℓ: Rd×X ×[K] →R be a
C-Lipschitz loss function, and let L(w) := 1
n
P
i∈[n] ℓ(w; xi, yi). Observe that the true gradient at
w is given as g(w) = 1
n
P
i∈[n] ∇wℓ(w; xi, yi), and each method discussed in this paper provides
a stochastic gradient oracle of the empirical loss L. In particular, we discuss LabelDP-Pro using
various denoisers as well as the debiased randomized response for this theoretical case study.
We can apply Lemma 3 to bound the excess error of PGD using the stochastic gradient oracles
arising out of each method. Table 4 provides upper bounds on the excess error for each method; we
derive these formally in Appendix E. The most technical part is to bound the expected squared norm
of the error in the stochastic gradient oracle with the ALTCONV denoiser, as shown below, which in
particular implies a bound on both the bias and the variance of the oracle.
6
Published as a conference paper at ICLR 2024
Lemma 4. Let IG, IP ⊆[n] be random subsets of size n1, n2 respectively. Let ˜g denote the noisy
gradient estimate from IG, namely, ˜g :=
1
n1
P
i∈IG ∇wℓ(w; xi, yi)+e for e ∼N(0, σ2C2
n1
·I). Let
A = conv
 {∇wℓ(w, (xi, κ))}i∈IP ,κ∈[K]

denote the convex body on which we project. Then, over
the choice of IG, IP , and e, we have
E

∥ProjA(˜g) −g∥2
2

≤O

C2 ·

1
n1 +
1
n2 +
σ√
log(Kn2)
√n1

.
We now interpret the bounds in Table 4, and compare it against the accuracy bounds in Table 3.
The rate of SELFSPAN gets rid of the dependence on dimension d; however, it comes at a price that
privacy amplification by subsampling is no longer applicable, due to which the noise multiplier σna
is larger than σa. This is indeed limiting, and if we instead use σa instead, SELFSPAN denoiser
ends up better than DP-SGD. The rate of SELFCONV improves upon the rate of SELFSPAN, but
again suffers from the same limitation that privacy amplification by subsampling is not applicable.
Finally, ALTCONV achieves error that is slightly larger than SELFCONV when using the same
noise multiplier (which can be see by comparing against SELFCONV when we use the noise
multiplier using privacy amplification), but since ALTCONV benefits from privacy amplification
by subsampling, it overall ends up being better than SELFCONV.
Note that the bounds in Table 4 hold only for convex loss functions. Moreover, they are upper
bounds on the excess error. For instance, while the bound in Lemma 3 is tight in the worst case,
better rates might be achievable under additional assumptions on the loss function. Despite these
limitations, we see in Table 4 that the excess error bounds align well with the experimental findings.
5
EVALUATION WITH ITEM-LEVEL PRIVACY
In this section, we evaluate the performance of LabelDP-Pro and compare it with baseline
approaches for item-level privacy. We detail the experimental setup in Section 5.1 and present
the main results in Section 5.2. We then demonstrate that LabelDP-Pro can be combined with
self-supervised learning to unlock even higher utility (Section 5.3).
5.1
EXPERIMENTAL SETUP
We compare our LabelDP-Pro on four benchmark datasets commonly used in LabelDP learning
evaluations: MNIST (LeCun et al., 1998), kMNIST (Clanuwat et al., 2018), FashionMNIST (Xiao
et al., 2017), and CIFAR-10 (Krizhevsky et al., 2009); against four established LabelDP baselines:
• Randomized Response (RR) (Warner, 1965): Method that randomly flips the label ( Section 2.2).
• RR with Debiased Loss (RR-Debiased): RR extension with unbiased loss function for training.
• Label Privacy Multi-Stage Training (LP-MST) (Ghazi et al., 2021): LP-MST trains the model
on disjoint partitions of the dataset in different stages. Specifically, we compare against LP-2ST,
a specific configuration with two training stages.
• Additive Laplace with Iterative Bayesian Inference (ALIBI) (Malek et al., 2021): A soft RR
mechanism that directly adds Laplace noises to one-hot encodings of training labels.
We also report the performance for DP-SGD as a reference, since our approach is built upon it. See
Appendix D for more details on the experiments.
5.2
MAIN RESULTS
As presented in Table 5, across both the MNIST and CIFAR-10 benchmarks, LabelDP-Pro
consistently surpasses baseline LabelDP mechanisms when ε < 1.0. Notably, the performance
gap widens as ε decreases. For instance, when ε = 0.2, previous baselines all achieve accuracy
levels close to random guessing, while LabelDP-Pro maintains non-trivial accuracy at 92.9% on
MNIST and 30.8% on CIFAR-10. These results demonstrate the effectiveness of LabelDP-Pro in
preserving utility, and they echo the theoretical analyses in Section 4. There also appears to be a
threshold ε∗such that when ε ≤ε∗, LabelDP-Pro outperforms RR, but when ε > ε∗, RR exhibit
superior performance. In Appendix D.4, we show how the number of classes (K) and the probability
for catastrophic failure (δ) affect ε∗.
Compared to DP-SGD, LabelDP-Pro also consistently exhibits superior performance, underscoring
the effectiveness of our Denoiser. Notably, this performance gap tends to be more pronounced when
7
Published as a conference paper at ICLR 2024
Table 5: Test accuracy on (a) MNIST-10 and (b) and CIFAR-10, for different ε’s. The best result for each
ε is boldfaced. We report the utility differences between LabelDP-Pro and the best baseline among RR,
RR-Debiased, LP-2ST, ALIBI (∆Baseline), and between LabelDP-Pro and DP-SGD (∆DP-SGD). LabelDP-Pro
outperforms baseline methods in the high-privacy regime.
Privacy
Baseline LabelDP Methods
DP-SGD
LabelDP-Pro (Ours)
Budget (ε)
RR
RR-DEBIASED
LP-2ST
ALIBI
Acc.
∆Baseline
∆DP-SGD
(a) MNIST-10
0.01
6.5
10.8
9.0
10.3
65.3
68.2
57.4 ↑
2.9 ↑
0.1
7.3
10.9
10.0
9.7
85.6
91.1
80.2 ↑
5.5 ↑
0.2
8.1
10.9
10.0
9.7
87.9
92.9
82.0 ↑
5.0 ↑
0.5
10.4
11.0
10.0
82.5
90.9
94.1
83.1 ↑
3.2 ↑
1.0
51.3
50.6
83.3
94.1
92.8
94.3
11.0 ↑
1.5 ↑
2.0
96.7
96.8
96.8
96.6
93.8
95.4
1.4 ↓
1.6 ↑
(b) CIFAR-10
0.05
10.0
10.0
10.0
9.9
10.1
16.0
6.0 ↑
5.9 ↑
0.1
10.0
10.0
10.0
9.9
24.6
27.0
17.0 ↑
2.4 ↑
0.2
10.0
10.0
10.0
17.9
29.8
30.8
12.9 ↑
1.0 ↑
0.5
10.0
10.0
35.8
34.4
36.9
40.2
5.8 ↑
3.3 ↑
1.0
17.0
10.0
60.9
51.3
43.5
44.8
16.1 ↓
1.3 ↑
Table 6: Test accuracy (%) on CIFAR-10 using Wide-ResNet18 with SelfSL. The PATE-FM results (also
using Wide-ResNet18 but with SemiSL) are from Table 1 of Malek et al. (2021). The best result for each ε
is boldfaced. We report the utility differences between LabelDP-Pro and the best baseline among RR, RR-
Debiased, RRWithPrior, PATE-FM (∆Baseline), and between LabelDP-Pro and DP-SGD (∆DP-SGD). Despite
PATE-FM’s stronger SemiSL pipeline (95.5% non-private accuracy, compared to our 90.9%), LabelDP-Pro
still outperforms PATE-FM in the high-privacy regime.
ε
Baseline LabelDP Methods
DP-SGD
LabelDP-Pro (Ours)
RR
RR-Debiased
RRWithPrior
PATE-FM
Acc.
∆Baseline
∆DP-SGD
0.01
2.5
2.7
24.6
-
71.8
74.4
43.1 ↑
2.6 ↑
0.02
3.4
2.1
50.4
-
81.6
82.4
32.0 ↑
0.8 ↑
0.05
3.5
2.7
70.8
-
85.1
85.5
14.7 ↑
0.4 ↑
0.18
4.7
3.1
76.8
73.4
86.4
86.6
9.8 ↑
0.2 ↑
0.29
5.1
3.7
76.8
86.9
87.0
87.2
0.3 ↑
0.2 ↑
0.5
6.0
9.8
78.1
-
87.1
87.4
9.3 ↑
0.3 ↑
1.6
88.1
88.0
83.1
93.7
87.2
87.7
6.5 ↓
0.5 ↑
dealing with smaller ε’s which can be potentially attributed to the fact that when ε is relatively large,
the noise introduced by DP-SGD is already minimal, leaving limited room for improvement by our
Denoiser. We also observe similar results on other datasets (see Appendix D.4).
5.3
LEVERAGING SELF-SUPERVISED LEARNING WITH LabelDP
Since the features are public in LabelDP, we can use self-supervised learning (SelfSL)
techniques (Chen et al., 2020a;b; Grill et al., 2020; He et al., 2020; Caron et al., 2021; Xie et al.,
2022) to obtain high-quality representations to further the utility of LabelDP Ghazi et al. (2021).
These representations can be learned solely from the input features without requiring labels; later,
they can be fed into the private supervised training pipelines alongside the corresponding labels.
We demonstrate this approach by evaluating LabelDP-Pro with SelfSL on CIFAR-10. Specifically,
we pre-train Wide-ResNet18 (He et al., 2016) as a representation extractor with unlabeled CIFAR-
10 images using the SimCLR algorithm (Chen et al., 2020a).
We then train classifiers on
the extracted representations using various LabelDP mechanisms, including RR, RR-Debiased,
RRWithPrior (Ghazi et al., 2021)2, DP-SGD, and LabelDP-Pro. See Appendix D.2 for more details.
We additionally include PATE-FM (Malek et al., 2021), a state-of-the-art semi-supervised learning
(SemiSL) based method, for comparison. It is noteworthy that PATE-FM benefits from a more
powerful SemiSL pipeline, with a non-private accuracy of 95.5% compared to our SelfSL pipeline’s
2RRWithPrior is a subroutine in the LP-MST method, where randomized labels are sampled with access
to label priors to improve accuracy.
When implementing this in the context of SelfSL, we follow the
procedure detailed in Ghazi et al. (2021, Section 5.2): we cluster training examples based on the SelfSL model
representations, and then query label histograms for each group using the discrete Laplace mechanism to obtain
label priors. The budget spared for the histogram query can be found in Appendix D.
8
Published as a conference paper at ICLR 2024
Table 7: Test AUC of RR, DP-SGD, and LabelDP-Pro on the Criteo data, with a different number of examples
contributed per user (k) and privacy budget (ε). The best results for each (ε, k) combination are boldfaced.
ε
k = 2
k = 5
k = 10
RR
DP-SGD
LabelDP-Pro
RR
DP-SGD
LabelDP-Pro
RR
DP-SGD
LabelDP-Pro
0.1
0.562
0.686
0.780
0.537
0.668
0.768
0.544
0.652
0.751
0.2
0.594
0.707
0.786
0.549
0.693
0.771
0.555
0.680
0.766
0.5
0.652
0.719
0.787
0.587
0.714
0.776
0.575
0.704
0.766
1.0
0.710
0.724
0.789
0.638
0.722
0.777
0.605
0.712
0.768
2.0
0.761
0.731
0.791
0.704
0.728
0.778
0.652
0.720
0.769
5.0
0.804
0.741
0.793
0.761
0.739
0.781
0.718
0.733
0.773
∞
0.823
0.824
0.824
non-private accuracy of 90.9%. As shown in Table 6, LabelDP-Pro consistently outperforms all
previous LabelDP baselines for ε ≤0.5. Remarkably, even when PATE-FM utilizes a stronger
SemiSL pipeline, achieving higher non-private accuracy than our SelfSL pipeline, LabelDP-Pro
still outperforms it at ε = 0.18 and ε = 0.29. We note that while LabelDP-Pro is a generic LabelDP
algorithm, both the SelfSL-based approach and PATE-FM (SemiSL-based) heavily rely on powerful
visual priors that can be derived from randomly augmented images alone. It is unclear how to
generalize to other domains where there are no powerful input data augmentations. Therefore, while
it is possible to plug LabelDP-Pro into a SemiSL pipeline as well by only privatizing (and denoising)
the supervised loss gradients, we leave the evaluation of this complicated setup for future work.
6
EVALUATION WITH USER-LEVEL PRIVACY
We finally evaluate LabelDP-Pro with user-level privacy, which protects a user’s entire contribution
to the model instead of guaranteeing privacy for individual items.
User-level DP offers more
stringent but realistic protection against adversaries, especially in advertising applications.
Dataset and model
We use the Criteo Attribution Modeling for Bidding dataset3 (Diemert
Eustache, Meynet Julien et al., 2017), which comprises a 30-day sample of live traffic data from
Criteo, a company that provides online display advertisements.
Each example in the dataset
corresponds to a banner impression shown to a user, and whether it resulted in a conversion attributed
to Criteo. The dataset retains user identifiers, and each user may contribute to multiple examples.
We randomly select 200, 000 users and gather their data to create the training dataset, and a disjoint
set of 50, 000 users for evaluation. For the training data, we cap the maximum number of examples
any one user can contribute to be k, where we vary k in {2, 5, 10}4. In cases where a user contributes
fewer than k examples, we use random re-sampling to augment their contributions to k examples.
We train an attribution model (Appendix D.3) with cross-entropy loss and report the AUC. We use
group privacy (see e.g. Vadhan, 2017) for randomized responses. For DP-SGD and LabelDP-Pro,
we compute per-user gradients and use them to replace the per-example gradients used in traditional
item-level DP-SGD. This inherently offers privacy guarantees at the user level (Kairouz et al.,
2021a; Xu et al., 2023).
Results
We report the performance of LabelDP-Pro, RR, and DP-SGD5. As shown in Table 7,
LabelDP-Pro consistently exhibits superior utility compared to RR when ε < 5, across various
numbers of examples per user (k).
As k increases, the performance gap between RR and
LabelDP-Pro becomes more pronounced. This widening gap can be attributed to the fact that
a user-level DP guarantee of (ε, δ) translates into an item-level DP guarantee of (ε/k, δ/keε) by
group privacy (e.g., Vadhan (2017)). So as k increases, the corresponding item-level privacy budget
decreases, which further accentuates the advantage of LabelDP-Pro over RR as shown in Section 5.
7
CONCLUSIONS AND FUTURE WORK
We studied LabelDP-Pro, a family of label DP training algorithms that interleaves gradient
projection steps with DP-SGD to improve the utility of the trained model. Our empirical study,
encompassing item-level and user-level privacy, demonstrates that such projection-based algorithms
improve the state-of-the-art utility in the high-privacy regime. We further support our empirical
findings with theoretical analyses based on bias-variance trade-offs. An important direction is to
3https://ailab.criteo.com/criteo-attribution-modeling-bidding-dataset/
4The distribution of the number of examples contributed by each user is shown in Figure 5 (Appendix D.4).
5We do not include methods based on SemiSL or SelfSL in our analysis, because it is not clear how to
effectively adapt those algorithms designed for image classification data to the domain of online advertising.
9
Published as a conference paper at ICLR 2024
explore more efficient denoisers. Currently, the memory-efficient approach demands approximately
200 iterations to reach convergence, presenting a computation bottleneck within the overall training
process.
In addition, we aspire to investigate the potential of LabelDP-Pro in the context of
regression tasks Ghazi et al. (2023), thereby expanding its applicability beyond the scope of the
classification tasks that we study.
10
Published as a conference paper at ICLR 2024
REFERENCES
A proposal for privacy preserving ad attribution measurement using Prio-like architecture. https:
//github.com/patcg/proposals/issues/17.
Mart´ın Abadi, Ashish Agarwal, Paul Barham, Eugene Brevdo, Zhifeng Chen, Craig Citro, Greg S.
Corrado, Andy Davis, Jeffrey Dean, Matthieu Devin, Sanjay Ghemawat, Ian Goodfellow, Andrew
Harp, Geoffrey Irving, Michael Isard, Yangqing Jia, Rafal Jozefowicz, Lukasz Kaiser, Manjunath
Kudlur, Josh Levenberg, Dandelion Man´e, Rajat Monga, Sherry Moore, Derek Murray, Chris
Olah, Mike Schuster, Jonathon Shlens, Benoit Steiner, Ilya Sutskever, Kunal Talwar, Paul Tucker,
Vincent Vanhoucke, Vijay Vasudevan, Fernanda Vi´egas, Oriol Vinyals, Pete Warden, Martin
Wattenberg, Martin Wicke, Yuan Yu, and Xiaoqiang Zheng. TensorFlow: Large-scale machine
learning on heterogeneous systems, 2015. URL https://www.tensorflow.org/.
Martin Abadi, Andy Chu, Ian Goodfellow, H Brendan McMahan, Ilya Mironov, Kunal Talwar, and
Li Zhang. Deep learning with differential privacy. In CCS, pp. 308–318, 2016.
Raef Bassily, Adam Smith, and Abhradeep Thakurta. Private empirical risk minimization: Efficient
algorithms and tight error bounds. In FOCS, pp. 464–473, 2014.
Atilim Gunes Baydin, Barak A Pearlmutter, Alexey Andreyevich Radul, and Jeffrey Mark Siskind.
Automatic differentiation in machine learning: a survey. JMLR, 18:1–43, 2018.
James Bradbury, Roy Frostig, Peter Hawkins, Matthew James Johnson, Chris Leary, Dougal
Maclaurin, George Necula, Adam Paszke, Jake VanderPlas, Skye Wanderman-Milne, and Qiao
Zhang.
JAX: composable transformations of Python+NumPy programs, 2018.
URL http:
//github.com/google/jax.
Mathilde Caron, Hugo Touvron, Ishan Misra, Herv´e J´egou, Julien Mairal, Piotr Bojanowski, and
Armand Joulin. Emerging properties in self-supervised vision transformers. In ICCV, pp. 9650–
9660, 2021.
Kamalika Chaudhuri and Daniel Hsu. Sample complexity bounds for differentially private learning.
In COLT, pp. 155–186, 2011.
Ting Chen, Simon Kornblith, Mohammad Norouzi, and Geoffrey Hinton. A simple framework for
contrastive learning of visual representations. In ICML, pp. 1597–1607, 2020a.
Ting Chen, Simon Kornblith, Kevin Swersky, Mohammad Norouzi, and Geoffrey E Hinton. Big self-
supervised models are strong semi-supervised learners. In NeurIPS, pp. 22243–22255, 2020b.
Heng-Tze Cheng, Levent Koc, Jeremiah Harmsen, Tal Shaked, Tushar Chandra, Hrishi Aradhye,
Glen Anderson, Greg Corrado, Wei Chai, Mustafa Ispir, et al.
Wide & deep learning for
recommender systems. In 1st Workshop on Deep Learning for Recommender Systems, 2016.
Tarin Clanuwat, Mikel Bober-Irizar, Asanobu Kitamoto, Alex Lamb, Kazuaki Yamamoto, and David
Ha. Deep learning for classical Japanese literature. arXiv preprint arXiv:1812.01718, 2018.
Rachel Cummings, Damien Desfontaines, David Evans, Roxana Geambasu, Matthew Jagielski,
Yangsibo Huang, Peter Kairouz, Gautam Kamath, Sewoong Oh, Olga Ohrimenko, et al.
Challenges towards the next frontier in privacy. arXiv preprint arXiv:2304.06929, 2023.
Soham De, Leonard Berrada, Jamie Hayes, Samuel L Smith, and Borja Balle.
Unlocking
high-accuracy differentially private image classification through scale.
arXiv preprint
arXiv:2204.13650, 2022.
Carson Denison, Badih Ghazi, Pritish Kamath, Ravi Kumar, Pasin Manurangsi, Krishna Giri Narra,
Amer Sinha, Avinash Varadarajan, and Chiyuan Zhang. Private ad modeling with DP-SGD. In
AdKDD, 2023.
Diemert Eustache, Meynet Julien, Pierre Galland, and Damien Lefortier.
Attribution modeling
increases efficiency of bidding in display advertising. In AdKDD, 2017.
11
Published as a conference paper at ICLR 2024
Friedrich D¨ormann, Osvald Frisk, Lars Nørvang Andersen, and Christian Fischer Pedersen. Not all
noise is accounted equally: How differentially private learning benefits from large sampling rates.
In MLSP, 2021.
Vadym Doroshenko, Badih Ghazi, Pritish Kamath, Ravi Kumar, and Pasin Manurangsi. Connect
the dots: Tighter discrete approximations of privacy loss distributions. PoPETS, 2022.
Cynthia Dwork and Aaron Roth. The algorithmic foundations of differential privacy. Found. Trends
Theor. Comput. Sci., 9(3-4):211–407, 2014a.
Cynthia Dwork and Aaron Roth. The Algorithmic Foundations of Differential Privacy. Foundations
and Trends® in Theoretical Computer Science, 9(3-4):211–407, 2014b.
Cynthia Dwork, Krishnaram Kenthapadi, Frank McSherry, Ilya Mironov, and Moni Naor. Our data,
ourselves: Privacy via distributed noise generation. In EUROCRYPT, pp. 486–503, 2006a.
Cynthia Dwork, Frank McSherry, Kobbi Nissim, and Adam D. Smith.
Calibrating noise to
sensitivity in private data analysis. In TCC, pp. 265–284, 2006b.
Hossein Esfandiari, Vahab Mirrokni, Umar Syed, and Sergei Vassilvitskii. Label differential privacy
via clustering. In AISTATS, pp. 7055–7075, 2022.
Badih Ghazi, Noah Golowich, Ravi Kumar, Pasin Manurangsi, and Chiyuan Zhang. Deep learning
with label differential privacy. In NeurIPS, pp. 27131–27145, 2021.
Badih Ghazi, Pritish Kamath, Ravi Kumar, and Pasin Manurangsi. Faster privacy accounting via
evolving discretization. In ICML, pp. 7470–7483, 2022.
Badih Ghazi, Pritish Kamath, Ravi Kumar, Ethan Leeman, Pasin Manurangsi, Avinash Varadarajan,
and Chiyuan Zhang. Regression with label differential privacy. In ICLR, 2023.
Aritra Ghosh, Himanshu Kumar, and P Shanti Sastry. Robust loss functions under label noise for
deep neural networks. In AAAI, 2017.
Google’s
DP
Library.
DP
Accounting
Library.
https://github.com/google/
differential-privacy/tree/main/python/dp accounting, 2020.
Sivakanth Gopi, Yin Tat Lee, and Lukas Wutschitz. Numerical composition of differential privacy.
In NeurIPS, pp. 11631–11642, 2021.
Jean-Bastien Grill, Florian Strub, Florent Altch´e, Corentin Tallec, Pierre Richemond, Elena
Buchatskaya, Carl Doersch, Bernardo Avila Pires, Zhaohan Guo, Mohammad Gheshlaghi Azar,
et al. Bootstrap your own latent - A new approach to self-supervised learning. In NeurIPS, pp.
21271–21284, 2020.
Huifeng Guo, Ruiming Tang, Yunming Ye, Zhenguo Li, and Xiuqiang He. DeepFM: a factorization-
machine based neural network for CTR prediction. arXiv preprint arXiv:1703.04247, 2017.
Elad Hazan. Introduction to Online Convex Optimization. MIT Press, 2022.
Kaiming He, Xiangyu Zhang, Shaoqing Ren, and Jian Sun.
Deep residual learning for image
recognition. In CVPR, pp. 770–778, 2016.
Kaiming He, Haoqi Fan, Yuxin Wu, Saining Xie, and Ross Girshick.
Momentum contrast for
unsupervised visual representation learning. In CVPR, pp. 9729–9738, 2020.
Peter Kairouz, Brendan McMahan, Shuang Song, Om Thakkar, Abhradeep Thakurta, and Zheng
Xu. Practical and private (deep) learning without sampling or shuffling. In ICML, 2021a.
Peter Kairouz, M´onica Ribero, Keith Rush, and Abhradeep Thakurta. Fast dimension independent
private adagrad on publicly estimated subspaces. In COLT, 2021b.
Antti Koskela, Joonas J¨alk¨o, and Antti Honkela. Computing tight differential privacy guarantees
using FFT. In AISTATS, pp. 2560–2569, 2020.
12
Published as a conference paper at ICLR 2024
Alex Krizhevsky, Geoffrey Hinton, et al. Learning multiple layers of features from tiny images.
Master’s thesis, Department of Computer Science, University of Toronto, 2009.
Alexey Kurakin, Steve Chien, Shuang Song, Roxana Geambasu, Andreas Terzis, and Abhradeep
Thakurta.
Toward training at ImageNet scale with differential privacy.
arXiv preprint
arXiv:2201.12328, 2022.
Yann LeCun, L´eon Bottou, Yoshua Bengio, and Patrick Haffner. Gradient-based learning applied to
document recognition. Proceedings of the IEEE, 86(11):2278–2324, 1998.
Daniel Levy, Ziteng Sun, Kareem Amin, Satyen Kale, Alex Kulesza, Mehryar Mohri, and
Ananda Theertha Suresh. Learning with user-level privacy. NeurIPS, 34:12466–12479, 2021.
Xuechen Li, Florian Tramer, Percy Liang, and Tatsunori Hashimoto. Large language models can be
strong differentially private learners. In ICLR, 2022.
Yuhan Liu, Ananda Theertha Suresh, Felix Xinnan X Yu, Sanjiv Kumar, and Michael Riley.
Learning discrete distributions: user vs item-level privacy. In NeurIPS, pp. 20965–20976, 2020.
Michal Lukasik, Srinadh Bhojanapalli, Aditya Menon, and Sanjiv Kumar. Does label smoothing
mitigate label noise? In ICML, pp. 6448–6458, 2020.
Xingjun Ma, Hanxun Huang, Yisen Wang, Simone Romano, Sarah Erfani, and James Bailey.
Normalized loss functions for deep learning with noisy labels. In ICML, pp. 6543–6553, 2020.
Mani Malek, Ilya Mironov, Karthik Prasad, Igor Shilov, and Florian Tram`er. Antipodes of label
differential privacy: PATE and ALIBI. In NeurIPS, pp. 6934–6945, 2021.
Brendan McMahan, Eider Moore, Daniel Ramage, Seth Hampson, and Blaise Aguera y Arcas.
Communication-efficient learning of deep networks from decentralized data. In AISTATS, pp.
1273–1282, 2017.
Sebastian Meiser and Esfandiar Mohammadi. Tight on budget? Tight bounds for r-fold approximate
differential privacy. In CCS, pp. 247–264, 2018.
Ilya Mironov. R´enyi differential privacy. In CSF, pp. 263–275, 2017.
Rafael M¨uller, Simon Kornblith, and Geoffrey E Hinton. When does label smoothing help?
In
NeurIPS, 2019.
Maud Nalpas and Alexandra White.
Attribution Reporting, May 2021.
https://developer.
chrome.com/en/docs/privacy-sandbox/attribution-reporting/.
Maxim Naumov,
Dheevatsa Mudigere,
Hao-Jun Michael Shi,
Jianyu Huang,
Narayanan
Sundaraman, Jongsoo Park, Xiaodong Wang, Udit Gupta, Carole-Jean Wu, Alisson G Azzolini,
et al. Deep learning recommendation model for personalization and recommendation systems.
arXiv preprint arXiv:1906.00091, 2019.
Nicolas Papernot, Shuang Song, Ilya Mironov, Ananth Raghunathan, Kunal Talwar, and ´Ulfar
Erlingsson. Scalable private learning with PATE. In ICLR, 2018.
Nicolas Papernot, Abhradeep Thakurta, Shuang Song, Steve Chien, and ´Ulfar Erlingsson. Tempered
sigmoid activations for deep learning with differential privacy. In AAAI, 2021.
Adam Paszke, Sam Gross, Francisco Massa, Adam Lerer, James Bradbury, Gregory Chanan, Trevor
Killeen, Zeming Lin, Natalia Gimelshein, Luca Antiga, Alban Desmaison, Andreas Kopf, Edward
Yang, Zachary DeVito, Martin Raison, Alykhan Tejani, Sasank Chilamkurthy, Benoit Steiner,
Lu Fang, Junjie Bai, and Soumith Chintala. PyTorch: An imperative style, high-performance
deep learning library. In NeurIPS, pp. 8024–8035, 2019.
Sofya Raskhodnikova,
Adam Smith,
Homin K Lee,
Kobbi Nissim,
and Shiva Prasad
Kasiviswanathan. What can we learn privately. In FOCS, pp. 531–540, 2008.
David E Rumelhart, Geoffrey E Hinton, and Ronald J Williams. Learning representations by back-
propagating errors. Nature, 323(6088):533–536, 1986.
13
Published as a conference paper at ICLR 2024
Kihyuk Sohn, David Berthelot, Nicholas Carlini, Zizhao Zhang, Han Zhang, Colin A Raffel,
Ekin Dogus Cubuk, Alexey Kurakin, and Chun-Liang Li. Fixmatch: Simplifying semi-supervised
learning with consistency and confidence. In NeurIPS, pp. 596–608, 2020.
David M Sommer, Sebastian Meiser, and Esfandiar Mohammadi. Privacy loss classes: The central
limit theorem in differential privacy. PoPETS, 2019.
Xinyu Tang, Milad Nasr, Saeed Mahloujifar, Virat Shejwalkar, Liwei Song, Amir Houmansadr, and
Prateek Mittal. Machine learning with differentially private labels: Mechanisms and frameworks.
PoPETS, 4:332–350, 2022.
Martin Thomson. Privacy Preserving Attribution for Advertising, February 2022. https://blog.
mozilla.org/en/mozilla/privacy-preserving-attribution-for-advertising/.
Florian Tramer and Dan Boneh. Differentially private learning needs better features (or much more
data). In ICLR, 2021.
Salil Vadhan. The Complexity of Differential Privacy. Springer, 2017.
Ruoxi Wang, Bin Fu, Gang Fu, and Mingliang Wang. Deep & cross network for ad click predictions.
In ADKDD, 2017.
Ruoxi Wang, Rakesh Shivanna, Derek Cheng, Sagar Jain, Dong Lin, Lichan Hong, and Ed Chi.
DCN V2: Improved deep & cross network and practical lessons for web-scale learning to rank
systems. In The Web Conference, 2021.
Weiran Wang and Miguel A Carreira-Perpin´an. Projection onto the probability simplex: An efficient
algorithm with a simple proof, and an application. arXiv preprint arXiv:1309.1541, 2013.
Yu-Xiang Wang, Borja Balle, and Shiva Kasiviswanathan. Subsampled R´enyi differential privacy
and analytical moments accountant. arXiv preprint arXiv:1808.00087, 2018.
Stanley L Warner. Randomized response: A survey technique for eliminating evasive answer bias.
JASA, 60(309):63–69, 1965.
Han Xiao, Kashif Rasul, and Roland Vollgraf.
Fashion-MNIST: a novel image dataset for
benchmarking machine learning algorithms. arXiv preprint arXiv:1708.07747, 2017.
Zhenda Xie, Zheng Zhang, Yue Cao, Yutong Lin, Jianmin Bao, Zhuliang Yao, Qi Dai, and Han Hu.
Simmim: A simple framework for masked image modeling. In CVPR, pp. 9653–9663, 2022.
Zheng Xu, Maxwell Collins, Yuxiao Wang, Liviu Panait, Sewoong Oh, Sean Augenstein, Ting Liu,
Florian Schroff, and H Brendan McMahan. Learning to generate image embeddings with user-
level differential privacy. In CVPR, 2023.
Da Yu, Huishuai Zhang, Wei Chen, and Tie-Yan Liu. Do not let privacy overbill utility: Gradient
embedding perturbation for private learning. In ICLR, 2021.
Da Yu, Saurabh Naik, Arturs Backurs, Sivakanth Gopi, Huseyin A Inan, Gautam Kamath, Janardhan
Kulkarni, Yin Tat Lee, Andre Manoel, Lukas Wutschitz, et al. Differentially private fine-tuning
of language models. In ICLR, 2022.
Guorui Zhou, Xiaoqiang Zhu, Chenru Song, Ying Fan, Han Zhu, Xiao Ma, Yanghui Yan, Junqi Jin,
Han Li, and Kun Gai. Deep interest network for click-through rate prediction. In KDD, 2018.
Xiong Zhou, Xianming Liu, Junjun Jiang, Xin Gao, and Xiangyang Ji. Asymmetric loss functions
for learning with noisy labels. In ICML, pp. 12846–12856, 2021.
14
Published as a conference paper at ICLR 2024
A
RELATED WORK
Differential privacy (DP, Dwork et al., 2006b;a) is a widely adopted notion that could formally
bound the privacy leakage of individual user information while still allowing for the analysis of
population-level patterns. When it comes to training deep neural networks with DP guarantees,
the go-to algorithm is DP-SGD, as introduced in the seminal work by Abadi et al. (2016). This
algorithm operates by clipping the contributions of gradients on a per-example basis and injecting
noise into the average gradient updates during each iteration of SGD.
Although several techniques have been proposed to enhance the utility of DP-SGD for specific
downstream applications (Papernot et al., 2021; Li et al., 2022; D¨ormann et al., 2021; Tramer &
Boneh, 2021; Kurakin et al., 2022; Yu et al., 2022; De et al., 2022; Denison et al., 2023; Cummings
et al., 2023), our work primarily focuses on utilizing the standard DP-SGD framework for the
purpose of generalization. We anticipate that the utility improvements demonstrated in our work
can be transferred to modern techniques.
The concept of label DP was initially introduced by Chaudhuri & Hsu (2011), who established
lower bounds on the sample complexity of private PAC learners. More recently, there has been a
growing interest in leveraging label-only privacy in the context of deep learning. The first work
is by Ghazi et al. (2021), which introduced Label Privacy Multi-Stage Training (LP-MST), an
approach for training deep neural classifiers while ensuring label DP. LP-MST operates by dividing
the dataset into disjoint partitions across various stages of training. Notably, the soft output of the
model from the previous stage serves as a prior, which is then used to improve the accuracy of the
label randomizer in subsequent stages. In Appendix F.2, they presented a theoretical analysis of an
algorithm referred to as LP-Normal-SGD, which involves projecting noisy gradients onto a subspace
to improve noise scaling. This algorithm is captured by our LabelDP-Pro family. However, to the
best of our knowledge, this algorithm has not been developed into a practical one.
Malek et al. (2021) introduced the idea that additive Laplace noise, combined with Bayesian
inference, better aligns with the demands of learning tasks.
Their contributions include the
development of a soft RR algorithm called ALIBI and a more intricate framework named PATE-
FM. PATE-FM combines the FixMatch semi-supervised learning algorithm (Sohn et al., 2020) with
the PATE private learning framework (Papernot et al., 2018). Notably, their PATE-FM framework
achieves state-of-the-art utility in image classification tasks.
While the benefits of integrating
unsupervised learning and semi-supervised techniques into the context of label DP have also been
recognized by other studies, such as those conducted by Esfandiari et al. (2022); Tang et al. (2022), it
is unclear if these approaches are immediately applicable to settings like online advertisement. This
is primarily due to the ambiguity surrounding what constitutes an effective unsupervised feature
extractor in such settings.
We also note that a few previous work has explored DP-SGD with gradient projection.
Yu
et al. (2021) proposed Gradient Embedding Perturbation (GEP), which firstly projects individual
private gradient into a non-sensitive low-dimensional anchor subspace, and then perturbs the
low-dimensional embedding and the residual gradient separately according to the privacy budget.
However, Yu et al. (2021) requires a public dataset to compute their gradient subspace; while such
data is possible for image classification tasks, it is typically not available for recommendation tasks,
which is one of the major applications of LabelDP. Kairouz et al. (2021b) introduced a projection
step to maintain the trajectory of the descent algorithm within the gradients’ subspace. While this
theoretically suggests faster convergence rates, empirical studies are not presented in the original
work, making it challenging to establish a direct comparison.
B
CENTRAL DP AND LOCAL DP
Recall the definition of (ε, δ)-DP in Definition 1. This notion is usually referred to as the central
DP when compared to an alternative notion of local DP defined below:
Definition 5 (LocalDP; Raskhodnikova et al. (2008)). Let ε ∈R>0, δ ∈[0, 1). A randomized
algorithm R is said to be (ε, δ)-LocalDP if for any two data points z, z′, and any subset S of
outputs of R, it holds that Pr[R(z) ∈S] ≤eε · Pr[R(z′) ∈S] + δ.
15
Published as a conference paper at ICLR 2024
In central DP, A acts as a trusted central server which has direct access to the dataset of sensitive
examples and outputs (aggregated and) privatized results. On the other hand, LocalDP assumes
that no central server can be trusted, and a randomized mechanism R runs locally by directly
randomizing each individual data point. Since the outputs of R already provide DP guarantees,
they can be sent to any (potentially malicious) central server for subsequent data analysis.
LocalDP can provide a privacy protection even when the trusted central server is compromised.
However, the stringent guarantee usually requires a LocalDP algorithm to inject extremely high
noise, severely compromising the utility of data analysis, especially in the high-privacy regime.
On the other hand, in central DP, the randomized mechanism A takes in an entire dataset D,
which allows it to compute a distributional property of D without noise. By randomizing only
the aggregated outcome, a central mechanism could better maintain the utility of distributional
data analysis while still protecting the privacy of individual data points. In the context of machine
learning, a typical example of LocalDP mechanism is the randomized response (RR) for LabelDP,
and a typical example of central DP mechanism is DP-SGD.
C
MEMORY-EFFICIENT PROJECTION VIA JACOBIAN VECTOR PRODUCT
We described a memory-efficient algorithm to compute the gradient projection in Section 3.2 using
advanced autodiff primitives. While autodiff has been widely used in various domains such as
atmospheric sciences and computational fluid dynamics, in most deep learning applications, only
a special case of the reverse mode autodiff is used to compute the batch gradients. But as we
discussed, the advanced autodiff primitives can be extremely useful to construct efficient gradient
projection algorithms. We skip the details of how such primitives are realized and refer the curious
readers to a survey by Baydin et al. (2018) and the references therein. Fortunately, modern deep
learning frameworks such as PyTorch (Paszke et al., 2019), Tensorflow (Abadi et al., 2015), and
JAX (Bradbury et al., 2018) are all starting to provide interfaces to such primitives to facilitate such
advanced usage.
In the following we present a pseudocode implementation of the two subroutines u 7→Gu for any
u ∈Rn2K, and v 7→G⊤v for any v ∈Rd that are required to compute G⊤(Gαt −˜g). The
pseudocode is written using the JAX functional style APIs, but can also be implemented using the
corresponding APIs in PyTorch or Tensorflow.
def G_u(f, theta, x, u):
"""Computes G * u using VJP (grad).
Args:
f: the neural network function that maps inputs to logits
given the model weights.
theta: the neural network model weights.
x: the (unlabeled) inputs.
u: an array of shape (n2, K).
Returns:
The sum of per-example per-class gradients weighted by u,
which is a nested array of the same structure as standard
gradients.
"""
def weighted_loss(theta):
logits = f(theta, x)
return - sum(u * log_softmax(logits, axis=-1))
return jax.grad(weighted_loss)(theta)
def G_transpose_v(f, theta, x, v):
"""Compute GˆT * v using JVP.
16
Published as a conference paper at ICLR 2024
Args:
f: the neural network function that maps inputs to logits
given the model weights.
theta: the model weights.
x: the (unlabeled) inputs.
v: a nested array of the same structure as the gradients.
Returns:
An array of the shape (n2, K), where each entry is the inner
product of each per-example per-class gradient with v.
"""
def raw_loss(theta):
logits = f(theta, x)
return -log_softmax(logits, axis=-1)
_, results = jax.jvp(raw_loss, (params,), (v,))
return results
D
EXPERIMENTAL DETAILS AND MORE RESULTS
D.1
BASELINE ALGORITHMS
RR-Debiased: RR-Debiased (originally proposed by Ghazi et al. (2021) and was referred to as
LP-RR-SGD) is an extension of RR that uses unbiased loss for training. To elaborate, let us consider
the multi-class classification setting where the input space is X and the label space Y = [K] :=
{1, . . . , K}. Given a training dataset D ∈X × Y and a loss function ℓ: RK × Y →R, our
objective is to train a model f : X →RK to learn the mapping from X to Y.
When using RR for training, each example (x, y) ∈D undergoes a randomization process that
produces a randomized label ˆy: Specifically, with a probability of p :=
K
eε+K−1, ˆy is set to a
randomly drawn value from [K], and with probability 1 −p, ˆy is set equal to y. However, the loss
ℓ(f(x), ˆy) introduces bias in estimating the true loss:
E[ℓ(f(x), ˆy)] = (1 −p) · ℓ(f(x), y) + p
K
X
κ∈[K]
ℓ(f(x), κ) ̸= ℓ(f(x), y).
To address this bias, RR-Debiased uses the following unbiased loss function ˆℓ(f(x), ˆy):
ˆℓ(f(x), ˆy) =
ℓ(f(x), ˆy) −p
K
P
κ∈[K] ℓ(f(x), κ)
1 −p
.
We direct the readers to Appendix F.1 of Ghazi et al. (2021) for more details of this method.
LP-2ST: Label Privacy Multi-Stage Training (LP-MST, Ghazi et al., 2021) trains the model on
disjoint partitions of the dataset in different stages. Specifically, our evaluation adopts LP-2ST,
a specific configuration of LP-MST that employs two training stages, which is the primary setup
evaluated in Ghazi et al. (2021). We use 40% of the data for the first stage and 60% for the second.
D.2
EXPERIMENTAL DETAILS
Hyper-parameters
We search for the best hyper-parameter settings for each evaluated approach.
For each set of hyper-parameters, we launch three independent runs with different random seeds.
The final results are derived by averaging the accuracy results across these three runs, selecting
the configuration that yields the highest performance. Table 8 provides the search space of hyper-
parameters for results presented in the main paper. For LabelDP-Pro, we also search for hyper-
parameters of the memory-efficient projection, including its learning rate in {0.01, 0.02, 0.05},
training step in {100, 200, 500}, and the label smoothing coefficient λ in {0.7, 0.75, 0.8, 0.85}.
17
Published as a conference paper at ICLR 2024
Table 8: Hyper-parameters for our experimental results presented in the main paper.
Optimizer
Learning rate
# Epochs
Batch size
Clipping norm
(DP-SGD & LabelDP-Pro)
Table 5.a
SGD
{0.01, 0.05, 0.1, 0.2}
{2, 5, 10}
{1024}
{1.0, 2.0, 5.0}
Table 5.b
SGD
{0.01, 0.05, 0.1, 0.2}
{50, 100}
{1024}
{1.0, 2.0, 5.0}
Table 6
SGD
{0.1, 0.2, 0.5, 1.0}
{1, 2, 5, 10, 20}
{1024}
{1.0, 2.0, 5.0}
Table 7
RMSprop
{1e-4, 5e-4, 1e-3}
{10, 20, 50}
{256, 1024, 4096}
{1.0, 2.0, 5.0}
Self-supervised learning
For the self-supervised learning (SelfSL) experiments presented in
Section 5.3, we pretrain the ResNet-18 (He et al., 2016) model on the CIFAR-10 dataset for 1, 000
epochs using SimCLR (Chen et al., 2020a). We use the Adam optimizer with a learning rate of
1 × 10−3 (weight decay set to 1 × 10−6), and a batch size of 1, 024. The pretraining takes around
26 hours on a single NVIDIA A100 GPU, with the pretraining loss trajectory presented in Figure 3.
0
200
400
600
800
1000
# Pretraining epoch
6.0
6.2
6.4
6.6
6.8
7.0
Train loss
Figure 3: Pretraining loss of SelfSL with SimCLR (Chen et al., 2020a) on CIFAR-10.
For our comparison with RRWithPrior (Ghazi et al., 2021), we need to split the privacy budget for
querying the prior and for training the model. The allocation of the budget for the prior across
different ε values is presented in Table 9.
Table 9: Budget for querying the prior in RRWithPrior for results in Table 6.
ε
Budget for prior querying
0.01
0.005
0.02
0.01
0.05
0.02
0.18
0.05
0.29
0.05
0.5
0.1
1.6
0.1
D.3
MODEL ARCHITECTURE
Table 10 provides the models used for item-level evaluation in Section 5.
For the experiments in user-level evaluation (Section 6), our feature set comprises a total of eleven
features, including ten categorical features and one numerical feature. The categorical features are:
campaign, a unique identifier for the campaign, and cat[1-9], nine contextual features associated
to the display. The numerical feature is cost, the price paid by Criteo for this display. Our goal
is to predict the last-touch attribution, namely whether the final click on an impression leads to a
conversion. Specifically, we firstly collect a subset of data where the impression has been clicked;
we then create a new label named last touch attribution conversion, which is defined as the
Boolean AND of the original conversion label and (click pos == click nb-1). We then build a
model to predict last touch attribution conversion based on the features.
18
Published as a conference paper at ICLR 2024
Table 10: Model architectures for item-level evaluation in Section 5.
(a) Model architecture for MNIST, FashionMNIST, and kMNIST
Layer
Parameters
Conv1
in channels: 1, out channels: 16, kernel size: 3, activation: ReLU
AvgPool
kernel size: 2, stride: 2
Conv2
in channels: 16, out channels: 16, kernel size: 3, activation: ReLU
AvgPool
kernel size: 2, stride: 2
FC1
out features: 16, activation: ReLU
FC2
out features: 10
(b) Model architecture for CIFAR-10
Layer
Parameters
Conv1
in channels: 3, out channels: 32, kernel size: 3, activation: ReLU
MaxPool
kernel size: 2, stride: 2
Dropout
ratio: 0.2
Conv2
in channels: 32, out channels: 64, kernel size: 3, activation: ReLU
MaxPool
kernel size: 2, stride: 2
Dropout
ratio: 0.2
Conv3
in channels: 64, out channels: 128, kernel size: 3, activation: ReLU
MaxPool
kernel size: 2, stride: 2
Dropout
ratio: 0.2
FC1
out features: 80, activation: ReLU
Dropout
ratio: 0.2
FC2
out features: 10
D.4
MORE RESULTS
Running time
We provide the single-epoch training time for baseline methods and our
LabelDP-Pro in Table 11, all implemented in JAX, utilizing a fixed batch size n1 = 1024. For
our method, we run 200 steps to solve the projection coefficients (see Section 3.2). Note that we
have excluded the ALIBI method from our comparisons. This is because our experiments for ALIBI
are based on the official ALIBI implementation in PyTorch6, making direct runtime comparisons
inappropriate. However, as presented in Table 7 of Tang et al. (2022), ALIBI should have a similar
running time to LP-MST.
Table 11: Single-epoch training time (seconds) for different tasks. Results for MNIST, CIFAR-10, and CIFAR-
10-SelfSL are reported on a single NVIDIA Tesla-P100 GPU, while results for Criteo Attribution are reported
on a single NVIDIA A100 GPU.
Task
RR
RR-debiased LP-2ST DP-SGD LabelDP-Pro
MNIST (Table 5)
2.40
88.34
331.30
44.52
59.93
CIFAR-10 (Table 5)
34.00
169.67
141.61
128.50
493.34
CIFAR-10-SelfSL (Table 6)
3.35
50.89
-
17.93
20.07
Criteo Attribution (Table 7), k = 5 17.52
-
-
205.67
315.69
As shown, despite the iterative steps to solve the projection coefficient, LabelDP-Pro only
incurs 1.11× ∼3.84× computation overhead compared to DP-SGD. This is because we use
jax.lax.fori loop(), a JAX primitive that ensures the loops are compatible with just-in-time
compilation, resulting in significant speedup gains. We also observe that the overhead is typically
smaller for tasks with small models (e.g., MNIST-10 and CIFAR-10-SelfSL), potentially due to
faster JVP because of lower weight dimension d.
Intersection point
As demonstrated in Table 5, there appears to be a threshold ε∗such that when
ε ≤ε∗, LabelDP-Pro outperforms RR, but when ε > ε∗, RR exhibit superior performance. Table 12
6https://github.com/facebookresearch/label dp antipodes
19
Published as a conference paper at ICLR 2024
demonstrates how the intersection point ε∗varies with the number of classes (K) and the probability
of catastrophic failure (δ).
Our theoretical case study also demonstrates this phenomenon. When eε ≫K, we see that the
additional excess error due to privacy Table 4 decays as ∼
p
K/eε. On the other hand, the same for
LabelDP-Pro with ALTCONV denoiser decays as ∼log0.25(K)/√ε (ignoring dependence on other
parameters). Thus, for a fixed K, we expect RR-Debiased to outperform LabelDP-Pro for large
enough ε.
• Number of classes (K): We find that the larger the number of classes, the larger ε∗becomes.
This can be also be seen in our theoretical case study in Table 4, since the intersection point of
p
K/eε and log0.25(K)/√ε increases with increasing K.
• Privacy parameter (δ): Since LabelDP-Pro is an approximate-DP mechanism, we also explore
the impact of varying δ, which represents the probability of catastrophic failure, on ε∗. We find
that when δ is smaller, ε∗decreases. Indeed, the reduced tolerance for failure cases necessitates
the injection of more noise into DP-SGD, ultimately leading to reduced utility in LabelDP-Pro.
Table 12: The intersection section point ϵ∗under different number of classes (i.e., K) and probability for
catastrophic failure (i.e., δ).
(a) ε∗vs K
K
ε∗
2
1.0 ∼1.1
5
1.1 ∼1.2
10
1.2 ∼1.3
(b) ε∗vs δ
δ
ε∗
1/n
1.3 ∼1.4
1/n1.1
1.2 ∼1.3
1/n1.2
1.0 ∼1.1
Item-level privacy
Table 13 presents results on CIFAR-10 with a larger range of ε. Table 14 and
Table 15 present results on the kMNIST (Clanuwat et al., 2018) and FashionMNIST (Xiao et al.,
2017) datasets. These results align with the findings presented in Table 5 of the main paper: we
observe consistent improvements achieved by LabelDP-Pro over LabelDP in high-privacy settings,
as well as over DP-SGD.
Table 13: Test accuracy of LabelDP, DP-SGD, and LabelDP-Pro on the CIFAR-10 dataset, for different ε’s.
The best result for each ε is boldfaced. LabelDP-Pro outperforms baseline LabelDP methods in the high-
privacy (i.e., small ε) regime.
Privacy Budget (ε)
Baseline LabelDP Methods
DP-SGD
LabelDP-Pro
RR
RR-DEBIASED
LP-2ST
ALIBI
0.05
10.0
10.0
10.0
9.9
10.0
16.0
0.1
10.0
10.0
10.0
9.9
24.6
27.0
0.2
10.0
10.0
10.0
17.9
29.8
30.8
0.5
10.0
10.0
35.8
34.4
36.9
40.2
1.0
17.0
10.0
60.9
51.3
43.5
44.8
2.0
77.6
58.8
63.8
64.2
51.4
52.0
5.0
80.4
80.2
81.7
82.3
59.5
59.8
10.0
81.5
81.8
83.5
83.5
63.6
63.7
Table 14: Test accuracy of LabelDP, DP-SGD, and LabelDP-Pro on the FashionMNIST dataset, for different
ε’s. The best result for each ε is boldfaced. LabelDP-Pro outperforms baseline LabelDP methods in the
high-privacy (i.e., small ε) regime.
Privacy Budget (ε)
Baseline LabelDP Methods
DP-SGD
LabelDP-Pro
RR
RR-DEBIASED
LP-2ST
ALIBI
0.01
13.9
10.0
10.0
9.9
59.1
63.0
0.1
15.7
10.0
10.0
10.7
73.4
75.7
0.2
19.8
10.1
10.0
10.7
75.6
77.9
0.5
46.9
44.8
10.9
69.2
79.7
79.8
1.0
75.7
73.9
68.7
76.5
81.5
81.7
2.0
84.6
85.0
84.8
82.3
82.3
82.4
20
Published as a conference paper at ICLR 2024
Table 15: Test accuracy of LabelDP, DP-SGD, and LabelDP-Pro on the kMNIST dataset, for different ε’s.
The best result for each ε is boldfaced. LabelDP-Pro outperforms baseline LabelDP methods in the high-
privacy (i.e., small ε) regime.
Privacy Budget (ε)
Baseline LabelDP Methods
DP-SGD
LabelDP-Pro
RR
RR-DEBIASED
LP-2ST
ALIBI
0.01
7.6
10.0
10.0
10.0
40.6
43.4
0.1
8.2
10.0
10.0
10.8
61.1
62.1
0.2
10.0
10.0
10.0
10.9
64.8
67.4
0.5
10.0
10.1
12.2
49.7
68.7
72.4
1.0
31.1
28.9
55.1
69.8
72.8
74.5
2.0
82.4
81.8
83.2
82.8
75
76.3
RR results in SelfSL
We notice that when ε < 1.6, combining RR with SelfSL results in a
surprisingly low accuracy (see Table 6), even worse than the performance of random guessing. To
investigate the reason, we visualize the confusion matrices on test data for the initialized model,
and for trained models with RR with ε = 0.1 and ε = 1.6 in Figure 4. We observed that at
initialization, the predictions are biased towards a few labels such as ‘1’, ‘5’, ‘6’, ‘7’, suggesting
that the representations from SelfSL are probably not very balanced. With the randomly initialized
weights, on average the prediction accuracy is around 10% as expected. However, we observe that
after training, for ε = 0.1, the model is severely confused by the strong noises in the training labels.
It maintains a strong bias to predict ‘1’, ‘6’ and ‘7’, but only when the true labels are not ‘1’, ‘6’, or
‘7’, respectively. As a result, the accuracy is even lower than random guessing (10%). In contrast,
when ε is set to a larger value (say, ε = 1.6) which returns the true label with higher probability, the
model’s prediction aligns better with the ground truth label.
Figure 4: Confusion matrices computed on test data for the randomly initialized model (left), and for trained
models with RR using ε = 0.1 (middle) and ε = 1.6 (right). When ε is small, the model is highly biased
towards predicting an unseen example as ‘1’, ‘6’, and ‘7’.
User-level privacy
Figure 5 presents the distribution of the number of examples contributed per
user in the Criteo Attribution dataset.
Figure 5: Examples per user in the Criteo Attribution dataset.
21
Published as a conference paper at ICLR 2024
E
PROOFS FOR THEORETICAL CASE STUDY (SECTION 4)
E.1
EXCESS ERROR IN STOCHASTIC CONVEX OPTIMIZATION
For completeness, we prove Lemma 3, restated below for convenience. The proof follows from
standard analysis of projected gradient descent (see, e.g., Hazan (2022)).
Lemma 3. For a convex loss function L, and a gradient oracle with bias α and expected squared
norm eC2, PGD over a convex set K ⊆Rd with diameter R and step size η =
R
e
C
√
T achieves the
following expected excess risk bound for the average iterate ¯wT := 1
T
PT −1
t=0 wt:
E [L ( ¯wT )] −L(w∗) ≤R eC
√
T
+ αR.
(1)
Proof. Suppose we have a gradient oracle with bias α and expected squared norm eC2. Let gt =
∇L(wt) denote the true gradient, and let ˜gt denote the stochastic gradient received at step t. Let
et = gt −˜gt be the error in the stochastic gradient. We have that ∥E et∥2 ≤α and E ∥˜gt∥2
2 ≤eC2.
Recall that PGD operates by computing wt+1 ←ProjK(wt −η˜gt). We have
L(wt) −L(w∗)
≤⟨gt, wt −w∗⟩
= ⟨et, wt −w∗⟩+ ⟨˜gt, wt −w∗⟩
= ⟨et, wt −w∗⟩+ 1
η · ⟨η˜gt, wt −w∗⟩
= ⟨et, wt −w∗⟩+
1
2η ·
 ∥wt −w∗∥2
2 + η2∥˜gt∥2
2 −∥wt −η˜gt −w∗∥2
2

≤⟨et, wt −w∗⟩+
1
2η ·
 ∥wt −w∗∥2
2 + η2∥˜gt∥2
2 −∥wt+1 −w∗∥2
2

= ⟨et, wt −w∗⟩+ η∥˜gt∥2
2
2
+
1
2η ·
 ∥wt −w∗∥2
2 −∥wt+1 −w∗∥2
2

,
where the second inequality is due to the fact that wt+1 is a projection of wt −η˜gt onto K and
w∗∈K, and hence ∥wt+1 −w∗∥≤∥wt −η˜gt −w∗∥.
Averaging over t = 0, . . . , T −1 and using Jensen’s inequality we have for ¯wT := 1
T
PT −1
t=0 wt that
L( ¯wT ) −L(w∗) ≤
1
T
PT −1
t=0 L(wt) −L(w∗)
≤
1
2ηT · ∥w0 −w∗∥2
2 +
η
2T
PT −1
t=0 ∥˜gt∥2
2 + 1
T
PT −1
t=0 ⟨et, wt −w∗⟩
≤
R2
2ηT +
η
2T
PT −1
t=0 ∥˜gt∥2
2 + 1
T
PT −1
t=0 ⟨et, wt −w∗⟩.
Taking expectation on both sides and using the convexity of L, we have
E[L( ¯wT ) −L(w∗)] ≤R2
2ηT + η eC2
2
+ 1
T
T −1
X
t=0
E [⟨et, wt −w∗⟩]
≤R2
2ηT + η eC2
2
+ 1
T
T −1
X
t=0
R · ∥E et∥2
≤R2
2ηT + η eC2
2
+ αR
≤R eC
√
T
+ αR
for η =
R
eC
√
T
.
E.2
ERROR BOUNDS OF STOCHASTIC GRADIENT ORACLES
We analyze the error introduced by various stochastic gradient oracles thereby using Lemma 3 to
obtain excess rates for projected gradient descent. First, we observe that just sampling a mini-batch
IG already introduces some variance in the stochastic gradients, which can be bounded as follows
for C-Lipschitz losses.
22
Published as a conference paper at ICLR 2024
We use the following notation in this section. Let g = L(w) := 1
n
P
i∈[n] ∇wℓ(w; xi, yi). For a
randomly sampled mini-batch IG ⊆[n] with |IG| = n1, let ˆg1 :=
1
n1
P
i∈IG ∇wℓ(w; xi, yi).
Lemma 6. Over the choice of a random subset IG ⊆[n] with |IG| = n1, it holds that
E ˆg1 = g
and
E

∥ˆg1 −g∥2
2

≤C2
n1
.
Proof. The first part holds by the linearity of expectation. To show the second part, let vi :=
∇wℓ(w; xi, yi) −g. We have that P
i∈[n] vi = 0. Hence for two indices i, j sampled without
replacement from [n], it holds that E [⟨vi, vj⟩] < 0, since E[vi|vj] = −vj/(n −1). Hence we have
E

∥ˆg1 −g∥2
2

= E
 1
n1
P
i∈IG vi

2
=
1
n2
1
 P
i∈IG E[∥vi∥2] + 2 P
i̸=j∈IG E[⟨vi, vj⟩]
|
{z
}
≤0

≤
C2
n1 .
We now analyze the excess error introduced by stochastic gradient oracles considered in Table 4,
and explicitly focus on the additional excess error that is introduced due to privacy. In order to do
so, we note that the non-private mini-batch gradient averages have a variance of C2
n1 , due to which
the PGD with this oracle achieves an excess error bound of
O
RC
√
T

1 +
1
√n1

.
(2)
The instantiations of LabelDP-Pro operate by obtaining a noisy gradient estimate ˜g = ˆg1 + e for
e ∼N(0, σ2C2
n1
· I), and then potentially projecting it. The addition excess error incurred due to
privacy can be deduced by subtracting (2) from the error bound.
NOOP (same as DP-SGD).
The vanilla DP-SGD algorithm performs PGD using a stochastic
gradient with zero bias (i.e., α = 0) and variance ω2 =
C2
n1 + dσ2C2
n1
, where recall that d is the
dimension of the parameter w. The first term of the variance comes from Lemma 6 and the second
term is due to the addition of noise. Using Lemma 3 and subtracting (2), this implies that the
additional excess error bound due to privacy is
O

RC
√
T ·
√
dσ
√n1

.
SELFSPAN.
Recall that this stochastic gradient oracle returns ˜z = ProjA(˜g) where A =
span
 {∇wℓ(w, (xi, κ)}i∈IG,κ∈[K]

. Since ˆg1 ∈A, we have that ˜z = ˆg1 + ProjA(e). This span
has dimension at most Kn1, which can be much smaller than d. Hence, this stochastic gradient
oracle has zero bias and variance ω2 = C2
n1 + Kn1σ2C2
n1
. Using Lemma 3 and subtracting (2), this
implies an additional excess error bound due to privacy of
O

RC
√
T ·
√
Kσ

.
Thus, we have reduced the
p
d/n1 term in excess error rate to
√
K. However, this comes at a
price! Unlike DP-SGD, we cannot leverage amplification by subsampling because the (unlabeled)
examples were used to define the span on which the noisy gradient was projected. Thus, the noise
multiplier σ required for the same privacy guarantee is (roughly
p
n/n1 times) larger, due to which
this bound is incomparable to the bound of DP-SGD.
SELFCONV.
Recall that this stochastic gradient oracle returns ˜z = ProjA(˜g) where A =
conv
 {∇wℓ(w, (xi, κ)}i∈IG,κ∈[K]

. We show the following.
Lemma 7. Let IG ⊆[n] be a random subset of size n1.
Let ˜g denote the noisy gradient
estimate from IG, namely, ˜g :=
1
n1
P
i∈IG ∇wℓ(w; xi, yi) + e for e ∼N(0, σ2C2
n1
· I). Let
A = conv
 {∇wℓ(w, (xi, κ)}i∈IG,κ∈[K]

denote the convex body on which we project. Then, over
23
Published as a conference paper at ICLR 2024
the choice of IG and e, we have
E

∥ProjA(˜g) −g∥2
2

≤O

C2

1
n1 +
σ√
log(Kn1)
√n1

.
Proof. Let ˜z := ProjA(˜g). Since A is a convex set, we have ⟨˜z −v, ˜z −˜g⟩≤0, for all v ∈A. By
definition, we have that ˆg1 ∈A and hence setting v = ˆg1 and rearranging, we arrive at

˜z −ˆg1, ˜z −ˆg1
≤⟨˜z, e⟩
≤max{| ⟨v, e⟩| : v ∈A}
(since ˜z ∈A)
= max{| ⟨∇wℓ(w; xi, κ), e⟩| : i ∈B2, κ ∈[K]} .
Thus,
E

∥˜z −ˆg1∥2
2

≤O

σC2√
log(Kn1)
√n1

,
which follows by observing that ∥∇wℓ(w; xi, κ)∥≤C and using the standard bound on the
Gaussian mean width of a convex hull of a finite set. Thus, by the triangle inequality and using
Lemma 6, we have that
E

∥˜z −g∥2
2

≤2 E

∥ˆg1 −g∥2
2 + ∥˜z −ˆg1∥2
2

≤O

C2
n1 +
σC2√
log(Kn1)
√n1

.
Thus it follows that the SELFCONV stochastic gradient oracle has bias α and error at most
O

C ·

1
√n1 +
√σ 4√
log(Kn1)
4√n1

. Moreover the expected square gradient norm eC ≤C (since
all vectors in the convex hull have norm at most C). Using Lemma 3 and subtracting (2), this
implies an additional excess error bound due to privacy of
O

RC

1
√n1 +
√σ 4√
log(Kn1)
4√n1

.
But as in SELFSPAN, we cannot leverage amplification by subsampling and the noise multiplier σ
here is (again, roughly
p
n/n1 times) larger as compared to DP-SGD. However, now we have a
non-zero bias, and hence a non-vanishing (in T) term.
ALTCONV.
Recall that this stochastic gradient oracle returns ˜z
= ProjA(˜g) where A =
conv
 {∇wℓ(w, (xi, κ)}i∈IP ,κ∈[K]

. We show Lemma 4 restated below for convenience.
Lemma 4. Let IG, IP ⊆[n] be random subsets of size n1, n2 respectively. Let ˜g denote the noisy
gradient estimate from IG, namely, ˜g :=
1
n1
P
i∈IG ∇wℓ(w; xi, yi)+e for e ∼N(0, σ2C2
n1
·I). Let
A = conv
 {∇wℓ(w, (xi, κ))}i∈IP ,κ∈[K]

denote the convex body on which we project. Then, over
the choice of IG, IP , and e, we have
E

∥ProjA(˜g) −g∥2
2

≤O

C2 ·

1
n1 +
1
n2 +
σ√
log(Kn2)
√n1

.
Proof. Let ˆg1, ˆg2 denote the gradient estimates from IG, IP respectively. Formally,
ˆg1 :=
1
n1
P
i∈IG ∇wℓ(w; xi, yi),
ˆg2 :=
1
n2
P
i∈IP ∇wℓ(w; xi, yi).
Let ˜z := ProjA(˜g). Since A is a convex set, we have:
⟨˜z −v, ˜z −˜g⟩≤0,
for all v ∈A .
By definition, we have that ˆg2 ∈A and hence setting w = ˆg2 and rearranging, we arrive at

˜z −ˆg2, ˜z −ˆg1
≤⟨˜z, e⟩
≤max{| ⟨v, e⟩| : v ∈A}
(since ˜z ∈A)
= max{| ⟨∇wℓ(w; xi, y), e⟩| : i ∈B2, y ∈[K]} .
Thus,
E

˜z −ˆg2, ˜z −ˆg1
≤O

σC2√
log(Kn2)
√n1

,
24
Published as a conference paper at ICLR 2024
which follows by observing that ∥∇wℓ(w; xi, κ)∥≤C and using the standard bound on Gaussian
mean width of a convex hull of a finite set. Thus, we have that
E

∥˜z −ˆg1∥2
2

≤E

∥˜z −ˆg1∥2 + ∥˜z −ˆg2∥2
= E

∥ˆg1 −ˆg2∥2 + 2

˜z −ˆg1, ˜z −ˆg2
≤O

C2
n1 + C2
n2 +
σC2√
log(Kn2)
√n1

,
where the last step uses Lemma 6. Thus, we have by the triangle inequality that
E

∥˜z −g∥2
2

≤2 E

∥˜z −ˆg1∥2
2 + ∥ˆg1 −g∥2
2

≤O

C2 ·

1
n1 +
1
n2 +
σ√
log(Kn2)
√n1

.
Moreover the expected squared gradient norm eC2 ≤C2 (since all vectors in the convex hull have
norm at most C). Using Lemma 3 and subtracting (2), this implies an additional excess error bound
due to privacy of
O

RC ·

1
√n1 +
1
√n2 +
√σ 4√
log(Kn2)
4√n1

.
While we again have a non-zero bias, and hence a non-vanishing term (in T), we can leverage
amplification by subsampling!
RR-Debiased.
Recall from Appendix D.1, that RR-Debiased uses a gradient oracle that first
samples i ∈[n], and using p =
K
eε+K−1, samples a random label ˆyi as
Pr[ˆyi = y] =
(
1 −p(K−1)
K
if ˆyi = yi
p
K
if ˆyi ̸= yi,
and then returns the stochastic gradient
˜g =
∇wℓ(w; xi, ˆyi) −p
K
P
κ∈[K] ∇wℓ(w; xi, κ)
1 −p
.
For ease of notation, let gx,y := ∇wℓ(w; x, y). It is easy to see (also shown in Ghazi et al. (2021)),
that this stochastic gradient has zero bias (i.e., E[˜g] = g). Moreover, the variance of the stochastic
gradient introduced by the randomized response for any fixed (xi, yi) is given as
E

∥˜g −gxi,yi∥2
2

=
1
(1 −p)2 E



gxi,ˆyi −p
K
X
κ∈[K]
gxi,κ −(1 −p)gxi,yi

2
2


=
1
(1 −p)2 · E
"
(1 −p + p
K ) · ∥p · (1 −1
K )gxi,yi −p
K
P
κ̸=yi gxi,κ∥2
2
+ p
K
P
κ′̸=i ∥(1 −p
K )gxi,κ′ −p
K
P
κ̸=κ′,i gxi,κ −(1 −p + p
K )gxi,yi∥2
2
#
≤O

p
(1 −p)2 · C2

.
Note that Ghazi et al. (2021) also establish a bound on the variance, however, they state an
approximate version that is only applicable when ε ≪1; whereas, the above bound holds for all
ε. In fact, their version follows from the bound above, since for ε ≪1, p ≈1 and 1 −p ≈ε/K,
and thus the bound becomes O(C2K2/ε2). On the other hand, when eε ≫K, we can approximate
p ≈K/eε and 1 −p ≈1, and hence the bound is O(C2K/eε).
Finally, when using a mini-batch IG with |IG| = n1, the variance due to randomized response
reduces by a factor of 1/n1, and hence using Lemma 3 and subtracting (2), this implies an additional
excess error bound due to privacy of
O

RC
√
T ·
√p
(1−p)√n1

.
25
