"""
    Sample test
"""

from django.test import SimpleTestCase # type: ignore

from app import calculate

class CalcTest(SimpleTestCase):
    """ Testing the calculate module. """

    def test_add_nums(self):
        """ Test adding numbers together. """
        res = calculate.add(8, 7)
        self.assertEqual(res, 15)


    def test_subtract_nums(self):
        """ Test subtracting numbers together. """
        res = calculate.subtract(8, 7)
        self.assertEqual(res, 1)

