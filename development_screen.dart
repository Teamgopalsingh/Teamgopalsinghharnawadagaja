import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/localization.dart';
import '../models/models.dart';
import '../services/supabase_service.dart';
import '../widgets/section_title.dart';

class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({Key? key}) : super(key: key);

  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen> {
  String _selectedFilter = 'सभी';
  List<DevelopmentProject> _allProjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await SupabaseService().fetchProjects();
    setState(() {
      _allProjects = projects;
      _isLoading = false;
    });
  }

  List<DevelopmentProject> get _filteredProjects {
    if (_selectedFilter == 'सभी') return _allProjects;
    return _allProjects.where((p) => p.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('nav_development')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.royalGold))
          : Column(
              children: [
                // Filter Tabs
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: AppColors.royalNavy,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['सभी', 'निर्माणाधीन', 'स्वीकृत', 'पूर्ण', 'प्रस्तावित'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            selectedColor: AppColors.royalGold,
                            backgroundColor: AppColors.cardDark,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.royalNavy : AppColors.textLight,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _selectedFilter = filter);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      project.title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.royalGold),
                                    ),
                                  ),
                                  _buildStatusBadge(project.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${project.wardName} • ${project.locationDetails}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                project.description,
                                style: const TextStyle(fontSize: 13, color: AppColors.textLight),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'बजट: ${project.estimatedBudget}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.saffronAccent),
                                  ),
                                  Text(
                                    'प्रगति: ${project.progressPercent.toInt()}%',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: project.progressPercent / 100,
                                backgroundColor: AppColors.royalNavy,
                                color: project.progressPercent == 100 ? AppColors.successGreen : AppColors.royalGold,
                                minHeight: 6,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = AppColors.royalNavy;
    Color border = AppColors.borderGold;

    if (status == 'पूर्ण') {
      bg = AppColors.successGreen.withOpacity(0.2);
      border = AppColors.successGreen;
    } else if (status == 'निर्माणाधीन') {
      bg = AppColors.saffronAccent.withOpacity(0.2);
      border = AppColors.saffronAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: border),
      ),
    );
  }
}
