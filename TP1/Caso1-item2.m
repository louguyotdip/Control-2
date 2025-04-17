%% Gráficas de la tecnsión en el capacitor, la corriente en el inductor y la entrada escalón 
clear; clc; close; 

data = xlsread('Curvas_Medidas_RLC_2025.xls', 'Hoja1');
t = data(:, 1);    % Tiempo (desde fila 1001 hasta 5000) que corresponde al primer escalon sin retardo
i = data(:, 2);    % Corriente
vc = data(:, 3);   % Tensión en el capacitor
vi = data(:, 4);   % Tensión de entrada

subplot(3,1,1); plot(t,i,'r'); title('I1,t');  
subplot(3,1,2); plot(t,vc,'b'); title('Vc,t'); 
subplot(3,1,3); plot(t,vi,'g');  title('U1,t');
