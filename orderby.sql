create database if not exists loja_online;
use loja_online;

create table if not exists categorias (
id int not null primary key auto_increment,
nome varchar (50) not null
);

create table if not exists produtos (
id int auto_increment primary key,
nome varchar (100) not null,
categoria_id int,
preco decimal (10,2),
quantidade_estoque int,
foreign key (categoria_id) references categorias (id)
);

insert into categorias (nome) values
('Roupas'), ('Calçados'), ('Acessórios');

insert into produtos (nome, categoria_id, preco, quantidade_estoque) values
('Camiseta', 1, 29.90,100),
('Calça Jeans', 1, 49.99, 75),
('Tênis Esportivo',2,89.99,50),
('Relógio',3, 199.99,20),
('Óculos de Sol', 3, 129.99,30),
('Jaqueta',1,79.99, 40),
('Bota',2,199.99,25),
('Mochila',3,59.99,60),
('Camisa Polo',1,39.99,80),
('Tênis Causal',2,69.99,70);

select * from categorias;
select * from produtos;

#Ordenação de dados
/*Order By: è uma clausula usada em SQL para ordenar o resultado de uma consulta.
Podendo ordenar os resultados em ordem crescente (ASC - Padrão de ordenação) executeordem decrescente (desc)*/

-- ordenar os produtos por preço em ordem crescente e decrescente
select nome, preco from produtos order by preco ASC;
select nome, preco from produtos order by preco;
select nome, preco from produtos order by preco desc;


-- ordenar produtos por nome em ordem decrescente e crescente
select nome,preco from produtos order by nome desc;
select nome,preco from produtos order by nome;


/*Agrupamentos (group by):  usada para agrupar linhas que tem valores iguais em colunas especificas
em grupo. Normalmente é usada com função de agregação (sum, count, avg, etc) para calcular valores agregados para cada grupo*/

-- contar o numero de produtos em cada categoria
select categorias.nome as "Categoria", count(produtos.id) as "Total de Produtos" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome;

-- calcular a media de preço dos produtos em cada categoria
select categorias.nome as  "Categoria", round(avg(produtos.preco),2) as "Valor Médio" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome;

/*Condição em Grupos (having): é usada para filtrar os resultados que usa Group By.
Ela é similar ao WHERE, mas é aplicada após a agregação dos dados, permitindo filtrar grupos em vez de linhas individuais*/

-- encontrar categorias com mais de 3 produtos
select categorias.nome as  "Categoria", count(produtos.id) as "Total de produtos" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome
having count(produtos.id) > 3; 

-- encontrar categorias onde a media de preço é superior a 50
select categorias.nome as  "Categoria", round(avg(produtos.preco),2) as "Valor Médio" from produtos
join categorias on produtos.categoria_id = categorias.id
group by categorias.nome
having round(avg(produtos.preco),2) > 50;

/*Paginação: refere-se ao processo de dividir um conjunto de resultados em páginas menores, geralmente para melhorar a performance e a usabilidade em interfaces.
Em SQL, isso é feito usando clausulas como LIMIT e OFFSET
Limit -> quantidades de registros a serem mostrados
Offset -> quantidade de registros a serem pulados */

-- vamos mostrar 3 produtos por páginas
select * from produtos order by preco;
-- pagina 1
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categorias" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 0;

-- pagina 2
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categorias" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 3;

-- pagina 3
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categorias" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 6;

-- pagina 4
select produtos.nome as "Produto", produtos.preco as "Preço", categorias.nome as "Categorias" from produtos
join categorias on produtos.categoria_id = categorias.id
order by produtos.preco
limit 3 offset 9;