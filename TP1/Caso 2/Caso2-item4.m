clear all;clc;close all;
%Sistema de tres variables de estado
%TP1 - Caso 2, item 4
% Constantes del sistema
Laa=366e-6;
J=5e-9;
Ra=55.6;
B=0;
K_i=6.49e-3;
Km=6.53e-3;
Va= 12;
% Parámetros de simulación
dt = 1e-7;         % Paso de integración (s)
t_final = 0.1;      % Tiempo total de simulación (s)
n = round(t_final / dt);  % Cantidad de pasos
% Variables de estado
ia = zeros(1, n);
omega = zeros(1, n);
theta = zeros(1, n);
t = linspace(0, t_final, n);
% Entrada de voltaje y torque de carga
Va = 12;           % V
TL = 0;            % N.m
% Integración de Euler
for k = 1:n-1
    dia = (-Ra * ia(k) - Km * omega(k) + Va) / Laa;
    domega = (K_i * ia(k) - B * omega(k) - TL) / J;
    dtheta = omega(k);
    
    ia(k+1) = ia(k) + dt * dia;
    omega(k+1) = omega(k) + dt * domega;
    theta(k+1) = theta(k) + dt * dtheta;
end
% Resultados
ia_max = max(ia);
omega_max = max(omega);
fprintf('Corriente máxima: %.3f A\n', ia_max);
fprintf('Velocidad angular máxima: %.3f rad/s\n', omega_max);
% Gráficos
figure;
subplot(2, 1, 1);
plot(t, omega);
ylabel('Velocidad angular \omega(t) [rad/s]');
grid on;

subplot(2, 1, 2);
plot(t, ia);
ylabel('Corriente ia(t) [A]');
xlabel('Tiempo [s]');
grid on;

% Calcular el torque máximo a partir de la corriente
T_max = Km * ia;  % Torque máximo en cada instante

% Resultados
ia_max = max(ia);
omega_max = max(omega);
fprintf('Corriente máxima: %.3f A\n', ia_max);
fprintf('Velocidad angular máxima: %.3f rad/s\n', omega_max);

% Graficar resultados
figure;

% Graficar Velocidad Angular
subplot(3, 1, 1);
plot(t, omega);
ylabel('Velocidad angular \omega(t) [rad/s]');
grid on;

% Graficar Corriente de Armadura
subplot(3, 1, 2);
plot(t, ia);
ylabel('Corriente ia(t) [A]');
xlabel('Tiempo [s]');
grid on;

% Graficar Torque máximo
subplot(3, 1, 3);
plot(t, T_max);
ylabel('Torque máximo T_{max}(t) [Nm]');
xlabel('Tiempo [s]');
grid on;

% Ajustar el layout de los gráficos
set(gcf, 'Position', [100, 100, 800, 600]); % Tamaño similar a figsize(12,6)

% Configuración simulación
t_etapa = 1e-7;
tF = 0.05;
delta_TL = 1e-9;
TL_max = 2.2e-5;
n = round(tF / t_etapa);
t = linspace(0, tF, n);

% Inicialización
omega = zeros(1, n);
ia = zeros(1, n);
TL = 0;
X = zeros(1, 3);

% Simulación
for k = 1:n-1
    X = modmotor(t_etapa, X, 12, TL);
    omega(k+1) = X(1);
    ia(k+1) = X(3);
    TL = min(TL + delta_TL, TL_max);
end

% Gráficos 
figure;
subplot(2,1,1);
plot(t, omega);
title('Velocidad Angular');
xlabel('Tiempo [s]');
ylabel('\omega(t) [rad/s]');
grid on;

subplot(2,1,2);
plot(t, ia);
title('Corriente');
xlabel('Tiempo [s]');
ylabel('ia(t) [A]');
grid on;

%% Nueva simulación
% Parámetros de simulación
t_etapa = 1e-7;
tF = 0.05;         % Tiempo total de simulación
delta_TL = 1e-9;   % Incremento de torque
TL_max = 2.128e-5; % Torque máximo
n = round(tF / t_etapa); % Cantidad de pasos
t = linspace(0, tF, n);

% Inicialización de las variables
omega = zeros(1, n);
ia = zeros(1, n);
TL = 0;            % Inicializamos el torque en 0
X = zeros(1, 3);

% Pre-asignación de memoria para los vectores de valores
omega_vals = zeros(1, n);
ia_vals = zeros(1, n);
TL_vals = zeros(1, n);

% Simulación: incrementar torque progresivamente y registrar los resultados
for k = 1:n-1
    % Guardamos los resultados actuales para graficarlos después
    omega_vals(k) = omega(k);
    ia_vals(k) = ia(k);
    TL_vals(k) = TL;
    
    % Simulamos el motor con el torque actual
    X = modmotor(t_etapa, X, 12, TL);  % 12 V de voltaje
    omega(k+1) = X(1);
    ia(k+1) = X(3);
    
    % Aumentamos el torque para el siguiente paso
    TL = min(TL + delta_TL, TL_max);  % Aumenta el torque, pero no pasa el máximo
end

% Agregar los últimos valores
omega_vals(n) = omega(n);
ia_vals(n) = ia(n);
TL_vals(n) = TL;

% Graficamos la evolución de la corriente, la velocidad angular y el torque
figure('Position', [100, 100, 800, 600]); % Equivalente a figsize(12,8)

% Gráfico 1: Velocidad Angular vs Tiempo
subplot(3, 1, 1);
plot(t, omega_vals);
title('Velocidad Angular y Corriente vs Tiempo');
xlabel('Tiempo [s]');
ylabel('Velocidad Angular \omega(t) [rad/s]');
grid on;

% Gráfico 2: Corriente vs Tiempo
subplot(3, 1, 2);
plot(t, ia_vals);
title('Corriente vs Tiempo');
xlabel('Tiempo [s]');
ylabel('Corriente ia(t) [A]');
grid on;

% Gráfico 3: Torque vs Tiempo
subplot(3, 1, 3);
plot(t, TL_vals);
title('Torque vs Tiempo');
xlabel('Tiempo [s]');
ylabel('Torque TL(t) [N.m]');
grid on;
