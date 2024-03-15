-- Active: 1698192534173@@127.0.0.1@8880@db_lab

-- 1

with "temp" as (
    select to_char("date", 'month') as "month", "shop_ref", 
            sum(price_per_one*amount) as income
    from sales
    group by to_char("date", 'month'), shop_ref
)
select "month", shop_ref, income,
       rank() over (partition by "month" order by income desc)
from "temp"

-- 2

select "month", nomenclature_ref, income, "rank"
from (
    select "month", nomenclature_ref, income,
           rank() over (partition by "month" order by income desc) as "rank"
    from (
        select to_char("date", 'month') as "month", nomenclature_ref, 
               sum(price_per_one*amount) as income
        from sales
        group by to_char("date", 'month'), "nomenclature_ref"
    ) t
) t
where "rank" <= 3

-- 3
 
select "month", shop_ref, responsible_ref, income,"rank"
from (
    select "month", shop_ref, responsible_ref, income,
           rank() over (partition by "month" order by income asc) as "rank"
    from (
        select to_char("date", 'month') as "month", shop_ref, responsible_ref,
               sum(price_per_one*amount) as income
        from sales
        group by to_char("date", 'month'), shop_ref, responsible_ref
    ) t
) t
where rank <= 5

-- 5

select mnt, shop_ref, income, income / inc_month as segment
from (
    select to_char("date", 'month') as mnt, shop_ref,
           sum(price_per_one*amount) as income,
           sum(sum(price_per_one*amount)) over (partition by to_char("date", 'month')) inc_month
    from sales
    group by to_char("date", 'month'), shop_ref
) t
order by mnt, segment desc