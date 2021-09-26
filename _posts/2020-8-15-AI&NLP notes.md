# NLP/AI Notes

This article serves as notes for AI or NLP related learning. It can be a starter index to access different materials.

## Pytorch

### Getting Started

[pytorch demo](https://colab.research.google.com/drive/1kRTXlwpdXfLMGQgwfud7-YaaHcMrt8BR)

[pytorch NN](https://colab.research.google.com/drive/19NfeEKaKfyV5tpKhtEqcnmL3Yjwg_xQz)

[pytorch training a classifier (CNN&the like)](https://colab.research.google.com/drive/1jtLweSVHEtzllGkZvOvxDzBUB1UbO8sy)

## TensorFlow

[tf1.x&tf2.x mnist demo](https://colab.research.google.com/drive/1T23nt3x1yTHeSVKcFGOrOM8JnQAifWAM#scrollTo=x_5WZp66-aUn)

Looks like the diff is slight if we use keras and operate at a high level.

## Concepts Assembly

### SGD

Refers to Stochastic Gradient Descent

the only param is **learning rate**, which is easily understandable.

### Adam

Adam is derived from adaptive moment estimation. It is basically the combination of two commonly used strategy:

1. Adaptive Gradient Algorithm: sets each parameter an individual learning rate.
2. RMS Propogation: per-param lr is based on the mean of the recent magnitudes of gradients

Params: **alpha**, **beta1**, **beta2** and **epsilon:**

1. alpha: initial learning rate. (0.001 by default)
2. beta1: the exponential decay rate for the first moment estimates (mean). (0.99 by default)
3. beta2: the exponential decay rate for the second moment estimates (uncentered variance). (0.999 by default)
4. epsilon: a very small number to prevent zero divisioin error. (1e-8 by default)

### Dropout

Dropout is a strategy to prevent over-fitting.

A fully connected layer covers all parameters and whereby the co-dependency amongst the neurons can curb the their individual power, leading to over-fitting.

Therefore, dropout silences a fraction *p* of the neurons during training, and make up for this silence during testing.

The only parm is the fraction **p**.

**Training Phase**

Ignore a random fraction *p* of neurons in each layer and of course their activation outputs.

**Testing Phase**

To compensate the drop output of each layer by silencing *p* of activation outputs, dropout decreases their output by a factor *p*.

### CrossEntropy and NLLLoss (Negative Log Likelihood Loss)

In pytorch, CrossEntropyLoss is mainly the same as NLLLoss. But NLLLoss doesn't do the log_softmax automatically. When we use NLLLoss, we need to add log_softmax at the top layer (the last layer namely).

Then what's cross entropy? Simply put,

$$
H(p,q) = -\sum\limits_{\forall x}p(x)log(q(x))
$$

In machine learning, we define the loss function base on this:

$$
J=-\frac{1}{N}(\sum \limits^N_{i=1}y_i*log(\hat y_i))
$$

where, $y$is the ground truth and $\hat y$ is the estimate value.

### RNN

[ref](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)

RNN refers to recurrent NN. They are networks with loops in them, allowing information to persist. If we unroll it,

![image.png](https://b3logfile.com/file/2020/07/image-c912f5a9.png?imageView2/2/w/1280/format/jpg/interlace/1/q/100)

The long-term dependency problem: information stored fades out and if we need to fetch context far away, we may fail. In practice, RNNs always fail to handle long-term dependency.

### LSTM

[ref](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)

LSTM refers to Long Short Term Memory networks. They are explicitly designed to resolve long-term dependency problem. Keeping information for long term is their default behavior, not demanding requirement.

The repeating patterns in RNNs are always a simple mapping like a tanh function. LSTM have the almost same chain but this linking is way more complicated.

The core idea is the cell state, which is carefully added or removed with a structure named cell gate. Gate is composed of a sigmoid operation and a bit-wise multiplication.

Structures inside: **forget gate layer**, **input gate layer&candicate values**, **output layer**.

### Viterbi Algorithm

In HMM model, this algorighm is computed merely based on the max probability. It is efficient in this way.

### Forward Algorithm

In HMM model, this algorithm is computed in an overall way--taking all possible pre states into consideration.

### Subword algorithms