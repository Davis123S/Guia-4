% PUNTO2  
load("heartData.mat");
N = size(heart_data,1);

%%
%PUNTO3
% a.Cambia la edad de los participantes de días a años. 
heart_data.age = heart_data.age/365;

%%
% b. Cambia las variables que se encuentran en código binario

% GENERO
genderCat = strings(N,1);
for i = 1:N
    if heart_data.gender(i) == 1
        genderCat(i) = "Hombre";
    else
        genderCat(i) = "Mujer";
    end
end
heart_data.Genero = genderCat;
%%

%FUMADOR
smokeCat = strings(N,1);
for i = 1:N
    if heart_data.smoke(i) == 1
        smokeCat(i) = "Fumador";
    else
        smokeCat(i) = "No fumador";
    end
end
heart_data.Fumador = smokeCat;
%%

%ALCOHOL
alcoCat = strings(N,1);
for i = 1:N
    if heart_data.alco(i) == 1
        alcoCat(i) = "Consume alcohol";
    else
        alcoCat(i) = "No consume alcohol";
    end
end
heart_data.Alcohol = alcoCat;
%%

%ACTIVIDAD FISICA
activeCat = strings(N,1);
for i = 1:N
    if heart_data.active(i) == 1
        activeCat(i) = "Con actividad fisica";
    else
        activeCat(i) = "Sin actividad fisica";
    end
end
heart_data.Activo = activeCat;
%%

%CARDIO
cardioCat = strings(N,1);
for i = 1:N
    if heart_data.cardio(i) == 1
        cardioCat(i) = "Con condición cardiaca";
    else
        cardioCat(i) = "Sin condición cardiaca";
    end
end
heart_data.Cardio = cardioCat;
%%

% c. Calculo IMC
IMC = heart_data.weight ./ (heart_data.height / 100).^2;
heart_data.IMC = IMC;

IMCcla = strings(N,1);
for i = 1:N
    if (IMC(i)<18.5)
        IMCcla(i)="Bajo peso";

    elseif (18.5<=IMC(i) && 24.9>=IMC(i))
        IMCcla(i)="Peso normal";

    elseif (25<=IMC(i) && 29.9>=IMC(i))
        IMCcla(i)="Sobre peso";

    else 
        IMCcla(i)="Obeso";
    end
end
heart_data.Clasificacion_IMC=IMCcla;
%%

% d. Calculo presión arterial
ap_hi = heart_data.ap_hi; 
ap_lo = heart_data.ap_lo;

presionMed = (ap_hi + 2 * ap_lo) / 3;

heart_data.Presion_Arterial_Media = presionMed;

%%
%PUNTO4,5,6
function interfazGrafica()
    % Crear la interfaz gráfica
    app = uifigure('Name', 'Graficas', 'Position', [100 100 600 400]);
    
    % Crear lista desplegable
    dropdown = uidropdown(app, 'Items', {'Personas con Enfermedades Cardiovasculares por Rango de Edad y Género', 'Índice de masa corporal vs Colesterol', 'Nivel de glucosa vs Presión arterial media','Media y desviacion'}, 'Position', [50 300 200 22]);
    
    % Botón Graficar
    botonGraficar = uibutton(app, 'Text', 'Graficar', 'Position', [300 300 100 22], 'ButtonPushedFcn', @(btnGraficar,event) graficarCallback(dropdown.Value));
end

function graficarCallback(selectedOption)
    load("heartData.mat");
    % Inicializar contadores para hombres y mujeres en diferentes rangos de edad
    edades_hombres = zeros(1, 6);
    edades_mujeres = zeros(1, 6);

    % Recorrer los datos y contar personas con enfermedades cardiovasculares en cada rango de edad
    for i = 1:length(heart_data.age)
        if strcmp(heart_data.cardio(i), 'Tiene una condicion cardiaca')
            edad = heart_data.age(i);
            genero = heart_data.gender(i);

            if edad <= 30
                if genero == 1
                    edades_hombres(1) = edades_hombres(1) + 1;
                elseif genero == 2
                    edades_mujeres(1) = edades_mujeres(1) + 1;
                end
    
            elseif edad <= 40
                if genero == 1
                    edades_hombres(2) = edades_hombres(2) + 1;
                elseif genero == 2
                    edades_mujeres(2) = edades_mujeres(2) + 1;
                end
    
            elseif edad <= 50
                if genero == 1
                    edades_hombres(3) = edades_hombres(3) + 1;
                elseif genero == 2
                    edades_mujeres(3) = edades_mujeres(3) + 1;
                end
    
            elseif edad <= 60
                if genero == 1
                    edades_hombres(4) = edades_hombres(4) + 1;
                elseif genero == 2
                    edades_mujeres(4) = edades_mujeres(4) + 1;
                end
    
            elseif edad <= 70
                if genero == 1
                    edades_hombres(5) = edades_hombres(5) + 1;
                elseif genero == 2
                    edades_mujeres(5) = edades_mujeres(5) + 1;
                end
    
            else
                if genero == 1
                    edades_hombres(6) = edades_hombres(6) + 1;
                elseif genero == 2
                    edades_mujeres(6) = edades_mujeres(6) + 1;
                end
            end
        end
    end

    % Generar la gráfica de barras
    edades = {'<= 30', '31-40', '41-50', '51-60', '61-70', '>= 71'};
    
    if strcmp(selectedOption, 'Gráfica de Barras Apiladas')
        subplot(1, 2, 1);
        bar(1:6, [edades_hombres; edades_mujeres]', 'stacked');
        title('Gráfica de Barras Apiladas');
        legend('Hombres', 'Mujeres');
    else
        subplot(1, 2, 2);
        bar(1:6, [edades_hombres; edades_mujeres]');
        title('Gráfica de Barras Agrupadas');
        legend('Hombres', 'Mujeres');
    end
    
    for i = 1:2
        subplot(1, 2, i);
        xlabel('Rango de Edad');
        ylabel('Cantidad de Personas');
        ylim([0 7000]); % Establecer el límite del eje y
        set(gca, 'xticklabel', edades);
    end

    if strcmp(selectedOption, 'Índice de masa corporal vs Colesterol')
        
        concardioIMC = zeros(1, length(heart_data.age));
        sincardioIMC = zeros(1, length(heart_data.age));
        concardioCol = zeros(1, length(heart_data.age));
        sincardioCol = zeros(1, length(heart_data.age));
        
        for i = 1:length(heart_data.age)
            IMC2(i)= (heart_data.weight(i))/((heart_data.height(i))^2);

            if heart_data.cardio(i)==1
                concardioIMC(i)=concardioIMC(i)+IMC2(i);
                concardioCol(i)=concardioCol(i)+heart_data.cholesterol(i);
            elseif heart_data.cardio(i)==0
                sincardioIMC(i)=sincardioIMC(i)+IMC2(i);
                sincardioCol(i)=sincardioCol(i)+heart_data.cholesterol(i);
            end
        end
        
        figure;
        scatter(concardioIMC, concardioCol, 'filled', 'MarkerFaceColor', 'b');
        hold on;
        scatter(sincardioIMC, sincardioCol, 'filled', 'MarkerFaceColor', 'r');
        xlabel('IMC');
        ylabel('Colesterol');
        title('Índice de masa corporal vs Colesterol');
        legend('Con enfermedad cardíaca', 'Sin enfermedad cardíaca');
        grid on;

    elseif strcmp(selectedOption, 'Nivel de glucosa vs Presión arterial media')
        
        concardioGlu = zeros(1, length(heart_data.age));
        sincardioGlu = zeros(1, length(heart_data.age));
        concardioPres = zeros(1, length(heart_data.age));
        sincardioPres = zeros(1, length(heart_data.age));
        
        for i = 1:length(heart_data.age)
            PresionMedia(i) =(((heart_data.ap_hi(i))+((heart_data.ap_lo(i))*2))/3);
            if heart_data.cardio(i)==1
                concardioGlu(i)=concardioGlu(i)+heart_data.gluc(i);
                concardioPres(i)=concardioPres(i)+PresionMedia(i);
            elseif heart_data.cardio(i)==0
                sincardioGlu(i)=sincardioGlu(i)+heart_data.gluc(i);
                sincardioPres(i)=sincardioPres(i)+PresionMedia(i);
            end
        end
 
        figure;
        scatter(concardioGlu, concardioPres, 'filled', 'MarkerFaceColor', 'b');
        hold on;
        scatter(sincardioGlu, sincardioPres, 'filled', 'MarkerFaceColor', 'r');
        xlabel('Glucosa');
        ylabel('Presion arterial media');
        title('Nivel de glucosa vs Presión arterial media');
        legend('Con enfermedad cardíaca', 'Sin enfermedad cardíaca');
        grid on;
    end
end

interfazGrafica(); % Llamar a la función para iniciar la interfaz
    
