ALTER TABLE active_subscriptions ADD COLUMN start_date DATE;
ALTER TABLE active_subscriptions ADD COLUMN end_date DATE;
ALTER TABLE active_subscriptions
ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'expired'
CHECK (status IN ('active', 'expired', 'cancelled'));

WITH v(email, plan_type, start_date, end_date) AS (
    VALUES
    ('ivan.petrov@mail.com', 'basic', '2026-01-01', '2026-02-01'),
    ('maria.smirnova@mail.com', 'premium', '2026-02-15', '2026-03-15'),
    ('alex.kuznetsov@mail.com', 'standard', '2026-03-01', '2026-04-01'),
    ('olga.volkova@mail.com', 'basic', '2026-01-10', '2026-02-10'),
    ('dmitry.sokolov@mail.com', 'premium', '2026-04-01', '2026-05-01')
)
UPDATE active_subscriptions
SET start_date = v.start_date::date,
    end_date = v.end_date::date
FROM v, users u, subscriptions s
WHERE u.email = v.email
  AND s.plan_type = v.plan_type
  AND active_subscriptions.user_id = u.user_id
  AND active_subscriptions.subscription_id = s.subscription_id;

UPDATE active_subscriptions
SET start_date = '2026-01-01', end_date = '2026-02-01'
WHERE start_date IS NULL;

ALTER TABLE active_subscriptions ALTER COLUMN start_date SET NOT NULL;
ALTER TABLE active_subscriptions ALTER COLUMN end_date SET NOT NULL;
ALTER TABLE active_subscriptions
ADD CONSTRAINT chk_active_subscriptions_dates CHECK (end_date > start_date);
ALTER TABLE active_subscriptions ALTER COLUMN status SET DEFAULT 'active';
