import numpy as np
import pylab

n_iter = 50
sz = (n_iter,)
random_values = np.random.normal(0.125,1.5,size=sz) # observations (normal about x_hat, sigma=0.1)
z = [np.array([random_values[i] + 0.25*i,0]) for i in range(len(random_values))]

del_t = 1.0 # Time
q_f = 0.05   # Process error
r = 0.1     # measurement error
# Variances
p_l = 1.5
p_lf = 0.
p_f = 1.5


#Initial conditions
x_hat = []
P = []
K = []

x_hat.append(np.array([1., 0.]))
P.append(np.array([[p_l, p_lf], [p_lf, p_f]]))
K.append(np.array([[1., 0.], [0., 1.]]))

# Creating matrices
F = np.array([[1., del_t], [0., 1.]])
H = np.array([[1, 0]])
Q = np.array([[del_t**3 * q_f / 3., del_t**3 * q_f / 2.], [del_t**3 * q_f / 2., del_t * q_f]])
R = np.array([[r, 0], [0, r]])

for t in range(1, n_iter):
    # Predict
    x_hat_interim = np.dot(F, x_hat[t-1]) # + np.dot(B[t], u[t])
    P_interim = np.dot(np.dot(F, P[t-1]), np.transpose(F)) + Q
    #print "P was ",P[t-1]
    #print "P_interim is ", P_interim

    #print "inverted matrix?: ",np.dot(np.dot(H, P_interim), np.transpose(H)) + R
    # Update
    K.append(np.dot(np.dot(P_interim, np.transpose(H)), np.linalg.inv(np.dot(np.dot(H, P_interim), np.transpose(H)) + R)))
    print "K is now", K[t]
    x_hat.append(x_hat_interim + np.dot(K[t], (z[t] - np.dot(H, x_hat_interim))))
    #print "error is ",z[t] - np.dot(H, x_hat_interim)
    P.append(np.dot((np.identity(len(K[t])) - np.dot(H, K[t])), P_interim))
    

#print x_hat
#print x_temp
#print x_hat[:]
print 
pylab.figure()
pylab.plot([z[i][0] for i in range(len(z))],'k+',label='noisy measurements')
pylab.plot([0] + [x_hat[i][0] for i in range(len(x_hat))],'b-',label='a posteri estimate')
pylab.legend()
pylab.xlabel('Iteration')
pylab.ylabel('Voltage')

pylab.figure()
pylab.title("Should converge to 0.25")
pylab.plot([x_hat[i][1] for i in range(len(x_hat))], label='derivative')

pylab.show()
