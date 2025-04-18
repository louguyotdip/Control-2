%% Gráficas de la tensión en el capacitor, la corriente en el inductor y la entrada escalón 
clear; clc; close; 

data = xlsread('Curvas_Medidas_RLC_2025.xls', 'Hoja1');
t = data(:, 1);    % Tiempo (desde fila 1001 hasta 5000) que corresponde al primer escalon sin retardo
i = data(:, 2);    % Corriente
vc = data(:, 3);   % Tensión en el capacitor
vi = data(:, 4);   % Tensión de entrada

subplot(3,1,1); plot(t,i,'r'); title('I1,t');  
subplot(3,1,2); plot(t,vc,'b'); title('Vc,t'); 
subplot(3,1,3); plot(t,vi,'g');  title('U1,t');

clear all;clc;close all;
% TP1- Caso 1- item 2

data = xlsread('Curvas_Medidas_RLC_2025.xls', 'Hoja1');
t = data(1001:5000, 1);    % Tiempo (desde fila 1001 hasta 5000) que corresponde al primer escalon sin retardo
i = data(1001:5000, 2);    % Corriente
vc = data(1001:5000, 3);   % Tensión en el capacitor
vi = data(1001:5000, 4);   % Tensión de entrada

StepInput = 12;  % Amplitud del escalón (12V)

% normalizo el t para que el escalón comience en t=0
t = t - t(1);  % Ahora t(1) = 0

% Selección de puntos para el método 
t_inic = 0.002;  % Tiempo inicial para primer punto 
[val lugar] = min(abs(t_inic - t)); 
y_t1 = vc(lugar);
t_t1 = t(lugar);

[val lugar] = min(abs(2*t_inic - t));
y_2t1 = vc(lugar);

[val lugar] = min(abs(3*t_inic - t));
y_3t1 = vc(lugar);

% Cálculo de parámetros intermedios 
K = vc(end) / StepInput;  % Ganancia estática
k1 = (y_t1 / StepInput) / K - 1;  % Valores normalizados
k2 = (y_2t1 / StepInput) / K - 1;
k3 = (y_3t1 / StepInput) / K - 1;

% Cálculo de constantes de tiempo para polos distintos
be = 4*k1^3*k3 - 3*k1^2*k2^2 - 4*k2^3 + k3^2 + 6*k1*k2*k3;
alfa1 = (k1*k2 + k3 - sqrt(be)) / (2*(k1^2 + k2));
alfa2 = (k1*k2 + k3 + sqrt(be)) / (2*(k1^2 + k2));
beta = (k1 + alfa2) / (alfa1 - alfa2);

% Conversión a constantes de tiempo físicas
T1p = -t_t1 / log(alfa1);
T2p = -t_t1 / log(alfa2);
T3p = beta * (T1p - T2p) + T1p;

% Función de transferencia estimada
sys_Gp = tf(K * [T3p 1], conv([T1p 1], [T2p 1]))

[y_estimada, t_estimada] = step(StepInput * sys_Gp, t(end));% para poder graficarla

% Verificacion gráfica
figure;
plot(t, vc, 'b', 'LineWidth', 1.5); hold on;           % Datos reales en azul
plot(t_estimada, y_estimada, 'r--', 'LineWidth', 1.5); % Modelo estimado rojo punteado
hold off;

title('Comparación: Respuesta Real vs Estimada');
xlabel('Tiempo (s)');
ylabel('Vc (V)');
legend('Real', 'Estimada', 'Location', 'best');
grid on;
