drop table wells_metro_mortgage_income;
create table wells_metro_mortgage_income (
msa_num NUMBER,
city VARCHAR(40),
state VARCHAR(3),
relief_complaints NUMBER,
total_complaints NUMBER,
percent_relief NUMBER,
income NUMBER,
home_price NUMBER,
home_price_to_income NUMBER
);

insert into wells_metro_mortgage_income select * from ( 


select distinct(msa_income_mortgage.msa_num), msa_income_mortgage.msa_name, msa_income_mortgage.state,
nvl(relief_complaints,0) relief_complaints, total_complaints, nvl((relief_complaints/total_complaints), 0) percent_relief, 
income, home_price, home_price_income_ratio from
(select msa_name, count(complaint_id) total_complaints from complaindata 
inner join zip_msa_mapping on to_char(zip_msa_mapping.zip_code) = complaindata.zip_code
  where ( company in (
      'Wells Fargo'--,
      --'JPMorgan Chase',
      --'Citibank',
      --'Bank of America'--,
      --'Ocwen',
      --'Nationstar Mortgage'
    ) 
    and
    product in ('Mortgage')
  ) 
  group by msa_name) total_data
 
  left join 
  
(select msa_name, count(complaint_id) relief_complaints from complaindata 
inner join zip_msa_mapping on to_char(zip_msa_mapping.zip_code) = complaindata.zip_code
  where ( company in (
      'Wells Fargo'--,
      --'JPMorgan Chase',
      --'Citibank',
      --'Bank of America'--,
      --'Ocwen',
      --'Nationstar Mortgage'
    ) 
    and
    product in ('Mortgage')
    and 
    company_response in (
      'Closed with monetary relief', 'Closed with non-monetary relief')
    ) 
  group by msa_name) relief_data on relief_data.msa_name = total_data.msa_name
  left join zip_msa_mapping on total_data.msa_name = zip_msa_mapping.msa_name
  
  inner join msa_income_mortgage on 
    instr(lower(zip_msa_mapping.msa_name), lower(msa_income_mortgage.msa_name))>0
  and instr(lower(zip_msa_mapping.state_msa), lower(msa_income_mortgage.state))>0 
  order by msa_num);