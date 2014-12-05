drop table wells_zip_mortgage_income;
create table wells_zip_mortgage_income (
zip varchar(5),
relief NUMBER,
total NUMBER,
percent_relief NUMBER,
income NUMBER,
home_price NUMBER,
home_price_to_income NUMBER
);

insert into wells_zip_mortgage_income select * from ( 

select zip_data.*, zip_home_price.average as home_price, 
  (zip_home_price.average/income) as mortgage_to_income from
(select total.zip_code, nvl(relief_complaints, 0) relief_complaints, total_complaints, 
  nvl((relief_complaints/total_complaints), 0) percent_relief,
  (median) as income from 
(select zip_code, count(complaint_id) total_complaints from complaindata 
  where ( company in (
      'Wells Fargo'--,
      --'JPMorgan Chase'--,
      --'Citibank'--,
      --'Bank of America'--,
      --'Ocwen'--,
      --'Nationstar Mortgage'
    ) 
    and
    product in ('Mortgage')
  ) group by zip_code) total 

left join


(select zip_code, count(complaint_id) relief_complaints from complaindata 
  where ( company in (
      'Wells Fargo'--,
      --'JPMorgan Chase'--,
      --'Citibank'--,
      --'Bank of America'--,
      --'Ocwen'--,
      --'Nationstar Mortgage'--
    ) 
    
    and
    product in ('Mortgage')
    and company_response in (
      'Closed with monetary relief', 'Closed with non-monetary relief')
    ) group by zip_code) relief
on relief.zip_code = total.zip_code
left join zip_income on to_char(zip_income.zip) = total.zip_code) zip_data
left join zip_home_price on zip_data.zip_code = zip_home_price.zip
where total_complaints >= 1 and (zip_home_price.average is not null) and 
(income is not null));