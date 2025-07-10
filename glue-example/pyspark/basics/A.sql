SELECT
    *
FROM
    (
        select
            region,
            product,
            avg(autonumber) as autonumber
        from
            test
        group by
            cube (region, product)
        order by
            product NULLS LAST,
            region nulls last
    ) pivot (
        avg(autonumber) for region in (
            'Central' Central,
            'East' East,
            'West' West,
            null Total
        )
    )
order by
    product nulls last