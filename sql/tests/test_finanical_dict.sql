-- Ensure metric uniqueness

SELECT metric_code, "order", com_type_code, COUNT(*)
FROM financial_dict
GROUP BY 1,2,3
HAVING COUNT(*) > 1;

-- Test gen_metric_id trigger function
INSERT INTO financial_dict (metric_code, "order", com_type_code, description)
VALUES ('TEST_METRIC', 1, 'COM_TYPE_1', 'Test Metric Description');

SELECT metric_id FROM financial_dict WHERE metric_code = 'TEST_METRIC' AND "order" = 1 AND com_type_code = 'COM_TYPE_1';
DELETE FROM financial_dict WHERE metric_code = 'TEST_METRIC' AND "order" = 1 AND com_type_code = 'COM_TYPE_1';