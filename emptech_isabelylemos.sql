#Criação de banco de dados caso não exista
create database if not exists emptech_isabelylemos;

#apontar o banco para o uso
use emptech_isabelylemos;
#Criação de tabelas
create table if not exists funcionarios
(
codFunc int auto_increment primary key,
nomeFunc varchar(255)not null
);

create table if not exists veiculos
(
codVeic int auto_increment primary key,
modelo varchar(255) not null,
placas varchar(20) not null,
codFunc int
);

#inserindo dados nas tabelas
insert into funcionarios(nomeFunc) values
('João Silva'), ('Maria Oliveira'), ('Pedro Santos'),
('Ana Costa'),('Lucas Almeida'),('Fernana Lima'),
('Isabely Lemos'), ('Yasmin Pires'),('Gustavo Lanna');


insert into veiculos (Modelo, Placas, codFunc) values
('Fiat Uno','ABC1D23',1),('Honda Civic','XYZ2E34',1),
('Toyota Corolla','LMN3F45',2),('Chevrolet Onix','OPQ4g56',3),
('VW Gol','UVW6I78',5),('Peugeot 208','YZA7j89',null),
('Hyundai HB20','VUT8H54', 7), ('Chevrolet Meriva', 'OPT6G76', 8), ('Ford Fiesta', 'DFS5G67', 9);

#Inner Join
select funcionarios.nomeFunc as Nome, veiculos.modelo from veiculos
join funcionarios on veiculos.codFunc = funcionarios.codFunc;

#Equi Join
select f.nomeFunc as Nome, v.modelo from veiculos v 
join funcionarios f using (codFunc);

#Left Join
/*Retorna todos os campos do lado esquerdo do Join que se relaciona
com o lado direito do join, mais os os registros que não relacionam
com o lado direito e que sejam do lado esquerdo. */

select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc);

#Rigth Join
/*Retorna todos os campos do lado direito do Join que se relaciona
com o lado esquerdo do join, mais os os registros que não relacionam
com o lado esquerdo e que sejam do lado direito. */

select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#full join
/*O Full Join não funciona para mySQL, porem uma solução para
obeter o resultado de uma tabela contendo, dados que se relacionam
ou não do lado esquerdo com o lado direito do join, mais os dados que 
se relacionam ou não do lado direito com o lado esquerdo do join, é
necessário que seja feito as query Left Join e Rigth Join, porem 
utilizando o UNION para unir as 02 querys para realizar a 
pesquisa.*/

select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

/* View - Estrutura de seleção que encapsula querys complexas para 
simplificar o uso ao usuario e facilitar as chamadas em aplicações
externas. */

create view func_Veic as
select f.nomeFunc as Nome, v.modelo from veiculos v
left join funcionarios f using (codFunc)
union
select f.nomeFunc as Nome, v.modelo from veiculos v
right join funcionarios f using (codFunc);

#chamando view
select * from func_veic;

create table atuacaoVendas
(
codAtuacao int auto_increment primary key,
descricao varchar(255) not null
);

alter table atuacaoVendas add column codFunc int;
alter table atuacaoVendas add constraint codFunc
foreign key (codFunc) references funcionarios(codFunc);

select * from atuacaoVendas; 

insert into atuacaoVendas (descricao, codFunc) values
('Vendas de Veiculos Novos', 1), ('Vendas de Veiculos Usados', 2),
('Manutenção e reparo de veiculos', 3),('Serviços de Pós-Vendas', 4),
('Consultoria de Vendas',null),('Programações e eventos especiais',6),
('Devolução Veículo', null), ('Seguro', 7), ('Limpeza do Veículo', 8);

#Cross Join
/*Este join ira criar relatorio onde irá fazer todas as combinações
possíveis entre as tabelas.
Ex.: Se cruzarmos as Tabelas Funcionario, Veiculos e AtuacaoVendas
onde teremos Tabela Funcionarios com 6 Registros, Tabela Veiculos
com 7 registros e Tabela AutuacaoVendas com 6 Registros, iremos um 
resultado de combinação 6 x 7 x 6 que totalizará 252 cobinações.
*/

select f.codFunc, f.nomeFunc, v.Modelo, v.Placas, a.descricao
from funcionarios f
cross join veiculos v
cross join atuacaoVendas a;

create table indicacoes
(
codIndicador int,
codIndicado int,
primary Key (codIndicador,CodIndicado),
foreign key (codIndicador) references Funcionarios(codFunc),
foreign key (codIndicado) references Funcionarios(codFunc)
);

insert into indicacoes (codIndicador,codIndicado) values
(1,2),(1,3),(2,4),(2,5),(4,6), (3,7), (3,8), (4,5);

#Self Join
/*Gera um resultado de relacionamento de dados de uma tabela com ela 
mesma, ou seja, um auto-relacionamento. */

select i1.codIndicador as 'ID Indicador', f1.nomeFunc as 'Nome Indicador',
i1.codIndicado as 'ID Indicado', f2.nomeFunc as 'Nome Indicado' from indicacoes i1
join funcionarios f1 on i1.codIndicador = f1.codFunc
join funcionarios f2 on i1.codIndicado = f2.codFunc;





-- 1. Função e Procedure
/*a. Crie uma função chamada `GetFuncionarioVeiculoCount` que recebe o 
código de um funcionário e retorna o número de veículos associados a esse 
funcionário.*/
delimiter //
create function GetFuncionarioVeiculoCount(id int) returns decimal(10,2)
begin
-- Declarar Variaveis
declare qtdTotal decimal(10,2);
  -- Buscar a quantidade de de veículos
select count(*) into qtdTotal from veiculos where veiculos.codFunc = id limit 1;
-- Verificar se o retorno é nulo
if qtdTotal is null then
return 0;
end if;
-- Retornar a quantidade de veículos
return qtdTotal;
end //
delimiter ;

#Executar Função
select GetFuncionarioVeiculoCount(5);


/*b. Crie um procedimento armazenado chamado `AddVenda` que insere uma
nova atuação de vendas na tabela `AtuacaoVendas`. O procedimento deve
receber uma descrição e adicionar a nova atuação de vendas.*/
delimiter //
create procedure AddVenda (Inclientesclientesclientesclientesclientesclientes descricao varchar(255))
begin
  insert into atuacaoVendas (descricao) values (descricao);
end //
delimiter ;
 
#Executar procedure
call AddVenda ('Reparo do Carro');
select * from atuacaoVendas;


-- 2. Trigger – O DESAFIO
/*a. Crie um gatilho chamado `BeforeInsertIndicacao` que verifica se o
funcionário indicado já foi indicado por outro funcionário. Se o funcionário já
tiver uma indicação, o gatilho deve lançar um erro e impedir a inserção.*/
delimiter //
create trigger BeforeInsertIndicacao
before insert on indicacoes
for each row
begin
  if exists (select 1 from indicacoes where codIndicado = new.codIndicado) then 
    signal sqlstate '45000'
	set message_text = 'O funcionário indicado já foi indicado por outro funcionário.';
  end if;
end //
delimiter ;

 -- Exemplo de indicação que já foi feita
 insert into indicacoes (codIndicador,codIndicado) values (2,5);
 
 
 
-- 3. View e Joins
/*a. Crie uma visão chamada `FuncionarioVeiculoAtuacao` que exibe todos os
funcionários, seus veículos e as atuações de vendas associadas. A visão
deve mostrar os campos: código do funcionário, nome do funcionário,
modelo do veículo, placas do veículo e descrição da atuação de vendas.*/
create view FuncionarioVeiculoAtuacao as
select 
    f.codFunc as "Código do Funcionário",
    f.nomeFunc as "Nome do Funcionáqrio",
    v.modelo as "Modelo do Veículo",
    v.placas as "Placa do Veículo",
    a.descricao as "Descrição da Atuação"
from funcionarios f
left join veiculos v on f.codFunc = v.codFunc
left join atuacaoVendas a on f.codFunc = a.codFunc;
    
select * from FuncionarioVeiculoAtuacao;


/*b. Execute uma consulta para mostrar a lista completa de funcionários, 
indicando se eles têm veículos e quais atuações de vendas estão associadas 
a cada veículo, usando um `LEFT JOIN` para incluir todos os funcionários, 
mesmo aqueles sem veículos ou atuações de vendas.*/

select 
    f.codFunc as 'Codigo Funcionario',
    f.nomeFunc as 'Nome Funcionario',
    v.modelo as 'Modelo Veiculo',
    v.placas as 'Placa Veiculo',
    a.descricao as 'Descricao Atuacao'
from funcionarios f
left join veiculos v on f.codFunc = v.codFunc
left join atuacaoVendas a on v.codFunc = a.codFunc
order by f.codFunc, v.codVeic, a.codAtuacao;
