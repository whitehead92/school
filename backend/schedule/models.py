from django.db import models


class Student(models.Model):
    name = models.CharField(max_length=200)


class Teacher(models.Model):
    name = models.CharField(max_length=200)


class Squad(models.Model):
    name = models.CharField(unique=True, max_length=100)


class SquadMembership(models.Model):
    class Meta:
        unique_together = ('squad', 'student')

    squad = models.ForeignKey(Squad, on_delete=models.CASCADE)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    start_date = models.DateField(auto_now_add=True)
    end_date = models.DateField()


class WeeklySchedule(models.Model):
    class DAY(models.IntegerChoices):
        MONDAY = 0
        TUESDAY = 1
        WEDNESDAY = 2
        THURSDAY = 3
        FRIDAY = 4
        SATURDAY = 5
        SUNDAY = 6

    squad = models.ForeignKey(Squad, on_delete=models.CASCADE)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    day = models.IntegerField(choices=DAY.choices)
    start_time = models.TimeField()
    end_time = models.TimeField()


class Lesson(models.Model):
    squad = models.ForeignKey(Squad, on_delete=models.CASCADE)
    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    start_date = models.DateField()
    end_date = models.DateField()


class LessonAttendance(models.Model):
    class STATUS(models.IntegerChoices):
        SKIPPED = 0
        ATTEND = 1
        REASONABLE = 2

    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    status = models.IntegerField(choices=STATUS.choices)
    comment = models.TextField()
