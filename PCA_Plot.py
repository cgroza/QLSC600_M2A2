#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 15 17:47:15 2019

@author: alaaabdelgawad
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
# import seaborn
import seaborn as sns

#reading data
vector = pd.read_csv('eigenvec1000.txt', delimiter=" ", header= None)
vector1 =pd.read_csv('eigenvec25000.txt',delimiter=" ", header= None)
vector=vector.iloc[:,0:4]
vector1=vector1.iloc[:,0:4]
diag = pd.read_csv('plink-MS.txt',delimiter=" ", header= None)
#changing col names
diag.columns = ['indx','1st','2nd','3rd','4th','MS']
vector.columns=['indx','count','PC1','PC2']
vector1.columns=['indx','count','PC1','PC2']
#merging two dataframe
combine= pd.merge(vector, diag, on="indx")
combine1=pd.merge(vector1,diag,on="indx")
#divide healthy and MS patient 
Ms1=combine1[(combine1['MS']==2)]
Hlt1=combine1[(combine1['MS']==1)]
Ms=combine[(combine['MS']==2)]
Hlt=combine[(combine['MS']==1)]
#extract pcs
pc111=Hlt1['PC1']
pc211=Hlt1['PC2']
pc11=Hlt['PC1']
pc21=Hlt['PC2']

pc12=Ms['PC1']
pc22=Ms['PC2']
pc122=Ms1['PC1']
pc222=Ms1['PC2']
#generate transparent colors from 0 to 100
#t=np.random.rand(2000)
#dotcolors=[(0.2, 0.4, 0.6, a) for a in t]

fig = plt.figure() 
sns.regplot(x=pc11,y=pc21,scatter_kws={'alpha':0.15},label='Control',fit_reg=False)
sns.regplot(x=pc12,y=pc22,scatter_kws={'alpha':0.15},label='MS',fit_reg=False)

#plt.scatter(pc11,pc21,c=dotcolors, s=200, edgecolors='None',label='Control')
#plt.scatter(pc12,pc22,c=dotcolors, s=200, edgecolors='None',label='MS')
plt.title('pc1 vs pc2',weight='bold')
plt.xlabel('pc1',weight='bold')
plt.ylabel('pc2',weight='bold')
plt.legend(loc='best') 
plt.show()
fig.savefig('plot1000.png')


fig2 = plt.figure() 
sns.regplot(x=pc111,y=pc211,scatter_kws={'alpha':0.5},label='Control',fit_reg=False)
sns.regplot(x=pc122,y=pc222,scatter_kws={'alpha':0.1},label='MS',fit_reg=False)

#plt.scatter(pc11,pc21,c=dotcolors, s=200, edgecolors='None',label='Control')
#plt.scatter(pc12,pc22,c=dotcolors, s=200, edgecolors='None',label='MS')
plt.title('pc1 vs pc2',weight='bold')
plt.xlabel('pc1',weight='bold')
plt.ylabel('pc2',weight='bold')
plt.legend(loc='best') 
plt.xlim((-0.04,0.01))
plt.show()
fig2.savefig('plot25000.png')

'''
vector1 = vector[(x>-0.02)]
pc11 = vector1.loc[:,(0,2)]
pc21 = vector1.loc[:,(0,3)]

fig2 = plt.figure()
x1=pc11.loc[:,2]
y1=pc21.loc[:,3]
plt.scatter(x1,y1)
plt.title('pc1 vs pc2',weight='bold')
plt.xlabel('pc1',weight='bold')
plt.ylabel('pc2',weight='bold')
plt.show()
fig2.savefig('plot2.png')
'''
import matplotlib.pyplot as plt
labels = '1b', '1d', '1f', '4','5','6','No Data'
sizes = [2,2,23,2,3,25,2]
colors = ['gold', 'yellowgreen', 'lightcoral', 'lightskyblue','blue','brown','gray']
explode = (0.1, 0.1, 0.1, 0, 0, 0, 0)  # explode 1st slice

# Plot
plt.pie(sizes, explode=explode, labels=labels, colors=colors,
autopct='%1.1f%%', shadow=True, startangle=140)

plt.axis('equal')

plt.show()