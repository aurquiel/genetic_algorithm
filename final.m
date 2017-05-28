clear
clc
n=input('Ingrese el tama�o del laberinto= ');
g=input('Ingrese el numero de generaciones= ');
p=input('Ingrese el numero de poblacion= ');

flag=0;
m=makeMaze(n); %genera el laberinto al azar

%pone en cero lo que no es pared
for i=1:length(m)
    for j=1:length(m)
        if (m(i,j)~=2)
            m(i,j)=0;
        end 
    end
end

savem=m; %para solve_image

l=length(m);

%crea la rejilla numeralizada
h=1; %inicializacion
for i=1:l
    for j=1:l
        rejilla(i,j)=h;
        h=h+1;
    end
end

rejilla

%se crea la poblacion en listas
for aux=1:p
    
    %se crea un padre al azar
    padre=reshape(randperm(l*l),1,l*l);

    %se hace cero las paredes en los padres
    for i=1:l
        for j=1:l
            if m(i,j)==2
                for k=1:l*l
                    if rejilla(i,j)==padre(k)
                        padre(k)=0;
                    end
                end
            end
        end
    end
    
    %elminar los ceros del padre
    padre=padre(padre~=0);
    
    %coloca el numero menor como entrada del laberinto al principio del
    %padre
    for i=1:length(padre)-1
        if (padre(1)>padre(i+1))
            num_aux=padre(1);
            padre(1)=padre(i+1);
            padre(i+1)=num_aux;       
        end    
    end     
    
    %se guarda el padre en una lista
    lista(aux,:)=padre;
    %relleno el fitness con cero
    fitness(aux)=0;
    
    %contenacion de los pasos y el fitness
    resultado(aux,:)=horzcat(lista(aux,:),fitness(aux));%matriz con la lista y los fitness
    
end

%se encuentra la salida del labaerinto el cual es el numero mayor del padre
salida=sort(padre);
salida=salida(length(padre))


%ciclo de generaciones
for aux=1:g    
    
    if  (flag==1)
        break;
    end
    
    %vaciar fitness
    
    for i=1:p
        resultado(i,length(resultado(1,:)))=0;
    end    
    
    
    %funcion fitness
    for i=1:p%ciclo for para evaluar cada una de los individuos
        pasos=resultado(i,:); %guardo el arreglo de pasos en la variable pasos
        pasos(length(pasos))=[];
        for j=1:(length(pasos)-1) %ciclo for para determinar la adyacencia y a�adiir puntaje   
            if ( (pasos(j)==pasos(j+1)-1)||(pasos(j)==pasos(j+1)+1)||(pasos(j)==pasos(j+1)+length(m))||(pasos(j)==pasos(j+1)-length(m)) )
                resultado(i,length(padre)+1)=resultado(i,length(padre)+1)+100;
            else
                break; %salgo del ciclo de adyacencia cuando el paso siguiente no es adyacente
            end           
        end
    end
    
    %ordenamiento de mayor a menor fitness
    [B,K]=sort(resultado(:,length(padre)+1));
    resultado2=resultado(K,1);
    for i=2:length(padre)
       resultado2=horzcat(resultado2,resultado(K,i));
    end
    %poblacion ya ordenada de menor a mayor fitness 
    resultado=horzcat(resultado2,B);
    
    %ciclo de cruce por orden simple
 
    for i=1:2:p-1
        
        %creacion de la mascara1 primer padre
        mascara= round(1.*rand(1,length(resultado(1,:))));
        mascara(1)=1;%garantiza el inicio
        mascara(length(resultado(1,:)))=1;%garantiza el fitness
        
        if (resultado(i,length(resultado(1,:)))>0)
           fin=resultado(i,length(resultado(1,:)))/100;
           for auxfin=1:fin
               mascara(auxfin+1)=1;
           end
          
        end
        
        %creacion de la mascara2egundo padre
        
        mascara2= round(1.*rand(1,length(resultado(1,:))));
        mascara2(1)=1;%garantiza el inicio
        mascara2(length(resultado(1,:)))=1;%garantiza el fitness
        
        if (resultado(i+1,length(resultado(1,:)))>0)
           fin=resultado(i+1,length(resultado(1,:)))/100;
           for auxfin=1:fin
               mascara2(auxfin+1)=1;
           end
           
        end
        
        %se toma la mascara1 y se dejan los individuos con 1 y se rellenan
        %en el orden de paracion del segundo padre
       
        hijo1=resultado(i,:).*mascara; %obtengo los elentos fijos en el primer hijo proveientes del padre 1
        
        %se procede a rellenar con los elentos del padre 2 en el orden en
        %que aparescan
        
        bool=0; %bandera para saber si hay un elemento del padre2 contenido en hijo1
        for encuentra=1:length(resultado(1,:)-1)
            for aux10=1:length(resultado(1,:)-1) 
                padre2=resultado(i+1,:);
                if(padre2(encuentra)==hijo1(aux10)) %hay un elemento en padre 2 que este en hijo1
                    bool=1;              %si lo hay bool=1
                end
            end
    
            if (bool==0) %si no lo hay entro aqui
                for aux11=1:length(resultado(1,:)-1)
                    if(hijo1(aux11)==0)  %busco el primer cero del hijo 1
                        hijo1(aux11)=padre2(encuentra); %cambio ese cero por el elemto del padre2 que no se ecnuentra en hijo1
                        break                  %salgo del for para no seguir cambiando ceros
                    end    
                end    
            end
    
            bool=0; %inicializo para buscar otra vez
        end
        
        hijo2=resultado(i+1,:).*mascara2; %obtengo los elentos fijos en el primer hijo proveientes del padre 2
        
        %se procede a rellenar con los elentos del padre 1 en el orden en
        %que aparescan
        
        bool=0; %bandera para saber si hay un elemento del padre2 contenido en hijo1
        for encuentra=1:length(resultado(1,:)-1)
            for aux10=1:length(resultado(1,:)-1) 
                padre1=resultado(i,:);
                if(padre1(encuentra)==hijo2(aux10)) %hay un elemento en padre 2 que este en hijo1
                    bool=1;              %si lo hay bool=1
                end
            end
    
            if (bool==0) %si no lo hay entro aqui
                for aux11=1:length(resultado(1,:)-1)
                    if(hijo2(aux11)==0)  %busco el primer cero del hijo 1
                        hijo2(aux11)=padre1(encuentra); %cambio ese cero por el elemto del padre2 que no se ecnuentra en hijo1
                        break                  %salgo del for para no seguir cambiando ceros
                    end    
                end    
            end
    
            bool=0; %inicializo para buscar otra vez
        end
        
        %regreso los hijos como nuevos padres
        resultado(i,:)=hijo1;
        resultado(i+1,:)=hijo2;
        
    %vaciar fitness
    
    for i=1:p
        resultado(i,length(resultado(1,:)))=0;
    end    
    
    
    %funcion fitness
    for i=1:p%ciclo for para evaluar cada una de los individuos
        pasos=resultado(i,:); %guardo el arreglo de pasos en la variable pasos
        pasos(length(pasos))=[];
        for j=1:(length(pasos)-1) %ciclo for para determinar la adyacencia y a�adiir puntaje   
            if ( (pasos(j)==pasos(j+1)-1)||(pasos(j)==pasos(j+1)+1)||(pasos(j)==pasos(j+1)+length(m))||(pasos(j)==pasos(j+1)-length(m)) )
                resultado(i,length(padre)+1)=resultado(i,length(padre)+1)+100;
            else
                break; %salgo del ciclo de adyacencia cuando el paso siguiente no es adyacente
            end           
        end
    end
    
    %Terremoto cada diez generaciones
    if  (mod(g,5)==0) % si el residuo de las generacaiones entre 10 da cero, se hace terremoto, esto aplica cada 10 generaciones
        for i=1:p     %ciclo for para evaluar cada una de los individuos
            salvar_pasos=(resultado(i,length(padre)+1))/100; %veo el fitness para saber si hay pasos corectos 
            aux_pasos=resultado(i,(salvar_pasos+2):length(padre)); %salvar los pasos a permutar en un vector auxiliar
            permutacion=aux_pasos(randperm(length(aux_pasos))); %permutacion randon del vecotr de pasos
            resultado(i,(salvar_pasos+2):length(padre))=permutacion; %regreso el elemento permutado al azar
        end
    end %fin del condicional del terremoto para 10 generaciones 
    
    
    %flag1=0; %inicializacion
    %Evaluar si se quedo en un callejon sin salida
    %for i=1:p%ciclo for para evaluar cada una de los individuos
     %   salvar_pasos2=(resultado(i,length(padre)+1))/100; %veo el fitness para saber si hay pasos corectos
      %  if (salvar_pasos2>=1)
       % aux_pasos3=resultado(i,(salvar_pasos2+1:length(padre))); %salvar los pasos a buscar en un vector auxiliar
     %   for j=1:(length(aux_pasos3)-1) %ciclo for para saber si aun quedan pasos adyacentes   
      %      if ( (aux_pasos3(1)==aux_pasos3(j+1)-1)||(aux_pasos3(1)==aux_pasos3(j+1)+1)||(aux_pasos3(1)==aux_pasos3(j+1)+length(m))||(aux_pasos3(1)==aux_pasos3(j+1)-length(m)) )
       %         flag1=1; %enciendo la bandera en uno de que hay un paso posible, no esta trancado
        %    end 
         %   if (flag==1)
         %       break;   %no busco mas bloques adyacentes
        %    end    
     %   end
      %  if (flag1==0) %si no hay adyacentes
      %     aux_pasos=resultado(i,2:length(padre));
      %     permutacion=aux_pasos(randperm(length(aux_pasos)));
      %     resultado(i,2:length(padre))=permutacion;
      %     resultado(i,length(padre)+1)=0;
      %  end 
      %  flag1=0; %inicializacion despues de comprobacion
      %  end
   % end
   
    %Evaluar si se llego a la salida
    for i=1:p
        valor=(resultado(i,length(padre)+1)/100)+1;
        if (resultado(i,valor)==salida)
            individuo=resultado(i,1:valor);
            flag=1;
        end    
    end
    
    end %fin del cruce 
    
    if  (flag==1)
        break;
    end
    resultado
    end %fin de las generaciones


individuo
aux

solve_image